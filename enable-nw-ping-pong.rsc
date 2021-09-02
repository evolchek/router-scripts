/tool netwatch
:if ([get [find comment ~ ":nw-ping-pong"] disabled]) do={
  enable [find comment ~ ":nw-ping-pong"]
}
