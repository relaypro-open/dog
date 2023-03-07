#!/bin/env python3

from rethinkdb import RethinkDB
from pprint import pprint
from benedict import benedict

r = RethinkDB()
conn = r.connect(host='rethinkdb', db='dog')
rulesets_result = r.table('ruleset').run(conn)
rulesets = []
rulesets_updated = benedict()

for ru in rulesets_result:
    rulesets.append(ru)
    for ruleset in rulesets:
        #pprint(ruleset)
        ruleset_id = ruleset.pop('id')
        ruleset_updated = benedict()
        ruleset_updated['name'] = ruleset['name']
        ruleset_updated['profile_id'] = ruleset['profile_id']
        inbound_rules = ruleset.get('rules').get('inbound')
        inbound_rules_updated = []
        for inbound_rule in inbound_rules:
            if inbound_rule.get('order'):
                del inbound_rule['order']
            #inbound_rule['order'] = 100
            #if inbound_rule.get('group_type') == 'GROUP':
            #    inbound_rule.update({'group_type': 'ROLE'})
            if inbound_rule.get('group_type') == 'ROLE':
                inbound_rule.update({'group_type': 'GROUP'})
            inbound_rules_updated.append(inbound_rule)
        ruleset_updated['rules', 'inbound'] = inbound_rules_updated
        outbound_rules = ruleset.get('rules').get('outbound')
        outbound_rules_updated = []
        for outbound_rule in outbound_rules:
            if inbound_rule.get('order'):
                del outbound_rule['order']
            #outbound_rule['order'] = 100
        ruleset_updated['rules', 'outbound'] = outbound_rules_updated
        rulesets_updated[ruleset_id] = ruleset_updated

for ruleset_id, ruleset in rulesets_updated.items():
    pprint(ruleset_id)
    pprint(ruleset)
    r.table('ruleset').get(ruleset_id).update(ruleset).run(conn)
