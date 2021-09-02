/tool netwatch disable [/tool netwatch find comment~":nw-(google|opendns)"]

:if ([/ip dhcp-client get [/ip dhcp-client find interface=WAN-Starlink] add-default-route] = "no") do={
  /ip dhcp-client set [/ip dhcp-client find interface=WAN-Starlink] add-default-route=yes
}