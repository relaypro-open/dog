<p align="center">
  <img src="../images/dog-segmented-green.network-200x200.png">
</p>

- [Hosts](#hosts)
- [Groups](#groups)
- [Zones](#zones)
- [Profiles](#profiles)
- [Services](#services)
- [Flan Scans](#flan-scans)
- [Links](#links)

## Hosts
  Each agent is listed in Hosts.
  ![Hosts](/images/dog_park-hosts-1280x787.png)
## Groups
  Hosts are assigned to a group.
  ![Groups](/images/dog_park-groups-1280x787.png)
  ![Group](/images/dog_park-group-1280x787.png)
## Zones
  Zones are static lists of IPs that can be referenced in Profiles.
  ![Zones](/images/dog_park-zones-1280x787.png)
  ![Zone](/images/dog_park-zone-1280x787.png)
## Profiles
  Profiles describe the access rules. Group are associated with a Profile.
  Groups, Zones and Services are references in Profile rules.
  ![Profiles](/images/dog_park-profiles-1280x787.png)
  ![Profile](/images/dog_park-profile-1280x787.png)
## Services
  Ports and protocols are defines in Services.
  ![Services](/images/dog_park-services-1280x787.png)
  ![Service](/images/dog_park-service-1280x787.png)
## Flan Scans
  Integration with [flan scan](https://github.com/cloudflare/flan).
## Links
  Links share lists of groups,zones and their addresses between dog_trainers.
  Used to share addresses across multiple environments.
  ![Links](/images/dog_park-links-1280x787.png)
  ![Link](/images/dog_park-link-1280x1573.png)
