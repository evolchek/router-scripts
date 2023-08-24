/import pub/scripts/config.rsc
:global config

:local listName "via-vpn"

:local ipsToRemove [:toarray ""]

:foreach id in=[/ip firewall address-list find list=$listName] do={
    :set ($ipsToRemove->[/ip firewall address-list get $id address]) $id;
}

:local addIpToAddressList do={
    if ([:len [/ip firewall address-list find (address=$ip && list=$listName)]]=0) do={
        /ip firewall address-list add list=$listName address=$ip comment=$server
    }
    :set ($ipsToRemove->$ip);
    :return $ipsToRemove
}

:foreach server in=($config->"viaVpnHosts") do={

    #force the dns entries to be cached
    :resolve $server

    :foreach dnsRecord in=[/ip dns cache all find name=$server] do={
        
        #if it's an A records add it directly
        :if ([/ip dns cache all get $dnsRecord type]="A") do={
            :set ipsToRemove [$addIpToAddressList ip=[/ip dns cache all get $dnsRecord data] server=$server listName=$listName ipsToRemove=$ipsToRemove]
        }
    

        #if it's a CNAME follow it until we get A records
        :if ([/ip dns cache all get $dnsRecord type]="CNAME") do={
            :local cname
            :local nextCname
            :set cname [/ip dns cache all find (name=$server && type="CNAME")]
            :set nextCname [/ip dns cache all find (name=[/ip dns cache all get $cname data] && type="CNAME")]

            :while ($nextCname != "") do={
                :set cname $nextCname
                :set nextCname [/ip dns cache all find (name=[/ip dns cache all get $cname data] && type="CNAME")]
            }
        
            #add the a records we found
            :foreach record in=[/ip dns cache all find (name=[/ip dns cache all get $cname data] && type="A")] do={
                :set ipsToRemove [$addIpToAddressList ip=[/ip dns cache all get $record data] server=$server listName=$listName ipsToRemove=$ipsToRemove]
            }
        }
    }
}

:foreach ip,id in=$ipsToRemove do={
    /ip firewall address-list remove $id
}