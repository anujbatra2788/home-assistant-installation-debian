# home-assistant-installation-debian

## Networking
If you are using in VM and the network keeps dropping below is only a workaround

``` nmcli c mod $(nmcli -g uuid c) ipv4.method manual ipv4.addresses "192.168.0.189/24" ipv4.gateway "192.168.0.1" ipv4.dns "8.8.8.8,8.8.4.4"

nmcli c up $(nmcli -g uuid c)
```
