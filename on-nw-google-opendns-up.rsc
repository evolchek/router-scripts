/import pub/scripts/throttle-run-script.rsc
:global throttleRunScript

/tool netwatch disable [/tool netwatch find comment~":nw-(google|opendns|ping-pong)"]

:if ([/ip dhcp-client get [/ip dhcp-client find interface=WAN-Starlink] add-default-route] = "no" && [/ip dhcp-client get [/ip dhcp-client find interface=WAN-Starlink] gateway ] != "192.168.100.1") do={

  /ip dhcp-client set [/ip dhcp-client find interface=WAN-Starlink] add-default-route=yes
  :delay 5s
  $throttleRunScript scriptName=notify-starlink-up interval=10
}