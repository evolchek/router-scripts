/import pub/scripts/secrets.rsc
:global secrets

/tool e-mail send to=($secrets->"adminEmail") subject="[router.lan] Starlink down" body="Starlink went down"
