# Command line

Compare all-active_g_v4 ipset with list of IPs in all group ipsets.  all-active_g_v4 should >=.

```bash
diff -w <(sudo /sbin/ipset save | grep -v all-active_g_v4 | grep -v _z_ \
| egrep "add" | grep -v "fe80" | awk '{print $3}' | sort -n | uniq)\
<(sudo /sbin/ipset list all-active_g_v4 | sort -n | uniq| sed -e '1,7d') | egrep "<|>"
```

Flush Ipsets

```bash
sudo iptables -F
sudo ip6tables -F
sudo ipset destroy
```
