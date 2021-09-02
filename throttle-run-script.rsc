/import pub/scripts/epoch-time.rsc
:global epochTime

:global throttleRunScript do={

  if ([:len $scriptName] = 0) do={
    :error "Script name is required"
  }

  if ([:len $interval] = 0) do={
    :error "Interval is required"
  }

  :global epochTime

  if (([$epochTime ] - [$epochTime [/system script get $scriptName last-started ]]) > $interval) do={
    /system script run $scriptName
  }
}