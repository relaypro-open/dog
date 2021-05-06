<p align="center">
  <img src="../../images/dog-segmented-green.network-200x200.png">
</p>

# Web Console: dog_park

- [Hosts](#hosts)
- [Groups](#groups)
- [Zones](#zones)
- [Profiles](#profiles)
- [Services](#services)
- [Flan Scans](#flan-scans)
- [Links](#links)

dog_park is the primary user interface for dog.

## Hosts

Each agent is listed in Hosts.  Agents appear as Hosts as they attach to dog_trainer.
<div align="center">
<img src="images/dog_park-hosts.png" width="95%"</img>
</div>

Hosts include local, public and ec2 public addresses.

<div align="center">
<img src="images/dog_park-host.png" width="95%"</img>
</div>

## Groups

Hosts are assigned to a group, usually when the Agent is configured, but assignments can be changed in the console.
<div align="center">
<img src="images/dog_park-groups.png" width="95%"</img>
</div>
<div align="center">
<img src="images/dog_park-group.png" width="95%"</img>
</div>

## Zones

Zones are static lists of IPs that can be referenced in Profiles.\
Fairly static Zones can be updated in the console, but highly dynamic Zones like block or allow lists can be modified via the dog_trainer API.

<div align="center">
<img src="images/dog_park-zones.png" width="95%"</img>
</div>
Zones can include both IPv4 and IPv6 addresses.
<div align="center">
<img src="images/dog_park-zone.png" width="95%"</img>
</div>


## Profiles

Profiles describe the access rules.

<div align="center">
<img src="images/dog_park-profiles.png" width="95%"</img>
</div>

Group are associated with a Profile. Groups, Zones and Services are references in Profile rules.\
Each rule can be active or inactive.\
Rule types include: basic, connlimit (connection limit), recent (rate limit)\
Source can be a Group or Zone.
The inbound rules are default DROP, outbound rules are default ACCEPT.

<div align="center">
<img src="images/dog_park-profile.png" width="95%"</img>
</div>


## Services

Ports and protocols are defines in Services.
<div align="center">
<img src="images/dog_park-services.png" width="95%"</img>
</div>
Multiple ports, each with a different protocol types can be defined per service
<div align="center">
<img src="images/dog_park-service.png" width="95%"</img>
</div>


## Flan Scans

Integration with the network vulnerablity scanner [Flan Scan](https://github.com/cloudflare/flan) is available.
<div align="center">
<img src="images/dog_park-flan_scans.png" width="95%"</img>
</div>
An example of a Host with a Flan Scan discovered CVE.
<div align="center">
<img src="images/dog_park-host-flan.png" width="95%"</img>
</div>


## Links

Links share Groups, Zones and Host addresses between dog_trainers, but not Profiles.\
This is useful for sharing access between servers managed by different business units.

<div align="center">
<img src="images/dog_park-links.png" width="95%"</img>
</div>

Link direction can be bidirectional, inbound, or outbound.\
Link address handling can combine each dog_trainer's ipsets (union), or add the links name as a prefix to the ipset names (prefix).
Connection information is for the other sides' RabbitMQ.
<div align="center">
<img src="images/dog_park-link.png" width="95%"</img>
</div>

