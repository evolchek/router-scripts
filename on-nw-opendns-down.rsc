/import pub/scripts/throttle-run-script.rsc
:global throttleRunScript

:if ([/ip dhcp-client get [/ip dhcp-client find interface=WAN-Starlink] add-default-route] = "yes") do={

  /ip dhcp-client set [/ip dhcp-client find interface=WAN-Starlink] add-default-route=no
  :delay 5s
  $throttleRunScript scriptName=notify-starlink-down interval=1800
}