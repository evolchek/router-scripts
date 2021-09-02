/import pub/scripts/secrets.rsc
:global secrets

/tool e-mail send to=($secrets->"adminEmail") subject="[router.lan] ping-pong down" body=(($secrets->"pingPongHost") . " went down")
