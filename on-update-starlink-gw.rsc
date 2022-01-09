if ($bound = 1 && $"gateway-address" != "192.168.100.1") do={
  /ip route set [/ip route find comment~":via-starlink"] gateway=$"gateway-address"
}