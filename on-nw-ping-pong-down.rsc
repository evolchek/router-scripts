/import pub/scripts/throttle-run-script.rsc
:global throttleRunScript

/tool netwatch enable [/tool netwatch find comment~":nw-google"]
:delay 10s
$throttleRunScript scriptName=notify-ping-pong-down interval=3600