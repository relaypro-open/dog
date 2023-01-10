# Based on saltstack.py (c) 2014, Michael Scherer <misc@zarb.org>
# Based on local.py (c) 2012, Michael DeHaan <michael.dehaan@gmail.com>
# Based on chroot.py (c) 2013, Maykel Moya <mmoya@speedyrails.com>
# Based on func.py
# (c) 2022, Drew Gulino 
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import os

from apiclient import APIClient, endpoint, retry_request
from apiclient import HeaderAuthentication,JsonResponseHandler,JsonRequestFormatter

HAVE_DOG = False
try:
    import dog.api as dc
    HAVE_DOG = True
except ImportError:
    pass

import os
from ansible import errors
from ansible.plugins.connection import ConnectionBase

DOCUMENTATION = """
    author: Drew Gulino
    name: dog
    short_description: Run tasks over dog
    description:
        - Run commands or put/fetch on a target via dog
        - This plugin allows extra arguments to be passed that are supported by the protocol but not explicitly defined here.
          They should take the form of variables declared with the following pattern C(ansible_winrm_<option>).
    version_added: "2.0"
    requirements:
        - dog (distributed firewall manager)
    options:
      # figure out more elegant 'delegation'
      base_url:
        default: http://localhost:8000/api/v2
        description:
            - Address of the dog_trainer
        env: [{name: ANSIBLE_DOG_BASE_URL}]
        ini:
        - {key: base_url, section: dog_connection}
        type: str
      apikey:
        description:
            - apikey to access dog_trainer
        env: [{name: ANSIBLE_DOG_BASE_URL}]
        ini:
        - {key: apikey, section: dog_connection}
        type: str
"""

class Connection(ConnectionBase):
    ''' Dog-based connections '''

    has_pipelining = False
    transport = 'dog'

    def __init__(self, play_context, new_stdin, *args, **kwargs):
        self.apikey = os.getenv("DOG_API_KEY")
        if self.apikey == None:
            print("ERROR: DOG_API_KEY not set")
        super(Connection, self).__init__(play_context, new_stdin, *args, **kwargs)
        self.host = self._play_context.remote_addr

    def _connect(self):
        if not HAVE_DOG:
            raise errors.AnsibleError("dog is not installed")
        super(Connection, self)._connect()
      
        base_url = self.get_option("base_url")
        self.client = dc.DogClient(base_url = base_url, apikey = self.apikey)
        self._connected = True
        res = self.client.get_host_by_hostkey(self.host)
        self.hostkey = res.get("hostkey")
        self._display.vvv("hostkey %s" % (self.hostkey))
        self.host = self.hostkey
        return self

    def exec_command(self, cmd, sudoable=False, in_data=None):
        ''' run a command on the remote minion '''
        super(Connection, self).exec_command(cmd, in_data=in_data, sudoable=sudoable)

        if in_data:
            raise errors.AnsibleError("Internal Error: this module does not support optimized module pipelining")

        self._display.vvv("EXEC %s" % (cmd), host=self.host)
        cmd = {"command":cmd, "use_shell":"true"} 
        res = None
        res = self.client.exec_command(id=self.hostkey, json=cmd)
        self._display.vvv("res %s" % (res))
        p = res[self.hostkey]
        if p['retcode'] == 0:
            return (0, p['stdout'], p['stderr'])
        else:
            return (p['retcode'], p['stdout'], p['stderr'])

    def _normalize_path(self, path, prefix):
        if not path.startswith(os.path.sep):
            path = os.path.join(os.path.sep, path)
        normpath = os.path.normpath(path)
        return os.path.join(prefix, normpath[1:])

    def put_file(self, in_path, out_path):
        ''' transfer a file from local to remote '''

        super(Connection, self).put_file(in_path, out_path)

        out_path = self._normalize_path(out_path, '/')
        self._display.vvv("PUT %s TO %s" % (in_path, out_path), host=self.host)
        files = {in_path: out_path}
        res = self.client.send_file(id=self.hostkey, files=files)
        return res

    # TODO test it
    def fetch_file(self, in_path, out_path):
        ''' fetch a file from remote to local '''

        super(Connection, self).fetch_file(in_path, out_path)

        in_path = self._normalize_path(in_path, '/')
        self._display.vvv("FETCH %s TO %s" % (in_path, out_path), host=self.host)
        content = self.client.fetch_file(id=self.hostkey, file=in_path)
        open(out_path, 'wb').write(content)

    def close(self):
        ''' terminate the connection; nothing to do here '''
        pass
