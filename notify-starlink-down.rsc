/import pub/scripts/config.rsc
:global config

/tool e-mail send to=($config->"adminEmail") subject="[router.lan] Starlink down" body="Starlink went down"
