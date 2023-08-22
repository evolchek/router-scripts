/import pub/scripts/config.rsc
:global config

/tool e-mail send to=($config->"adminEmail") subject="[router.lan] Starlink up" body="Starlink is back up"
