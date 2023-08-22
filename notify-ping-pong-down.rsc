/import pub/scripts/config.rsc
:global config

/tool e-mail send to=($config->"adminEmail") subject="[router.lan] ping-pong down" body=(($config->"pingPongHost") . " went down")
