/import pub/scripts/config.rsc
:global config

:local listName "via-vpn"

:local addIpToAddressList do={
    /ip firewall address-list {
        :local records [find (address=$ip && list=$listName)]
        :if ([:len $records]=0) do={
            add list=$listName address=$ip timeout=10m comment=$server
        } else={
            set $records timeout=10m
        }
    }
}

:foreach server in=($config->"viaVpnHosts") do={

    #force the dns entries to be cached
    :resolve $server

    /ip dns cache {

        :foreach dnsRecord in=[find name=$server] do={
            
            #if it's an A records add it directly
            :if ([get $dnsRecord type]="A") do={
                $addIpToAddressList ip=[get $dnsRecord data] server=$server listName=$listName ipsToRemove=$ipsToRemove
            }
        

            #if it's a CNAME follow it until we get A records
            :if ([get $dnsRecord type]="CNAME") do={
                :local cname
                :local nextCname
                :set cname [find (name=$server && type="CNAME")]
                :set nextCname [find (name=[get $cname data] && type="CNAME")]

                :while ($nextCname != "") do={
                    :set cname $nextCname
                    :set nextCname [find (name=[get $cname data] && type="CNAME")]
                }
            
                #add the a records we found
                :foreach record in=[find (name=[get $cname data] && type="A")] do={
                    $addIpToAddressList ip=[get $record data] server=$server listName=$listName ipsToRemove=$ipsToRemove
                }
            }
        }
    }
}