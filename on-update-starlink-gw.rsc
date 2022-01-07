if ($bound = 1 && [/ip dhcp-client get [/ip dhcp-client find interface=WAN-Starlink] gateway ] != "192.168.100.1") do={
  /ip route set [/ip route find comment~":via-starlink"] gateway=$"gateway-address"
}