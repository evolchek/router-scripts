:global epochTime do={
	# Usage
	# $epochTime [time input]
	# -----
	# Get current time
	# :put [$epochTime]
	# 
	# Read log time in one of these formats "aug/31/2021 18:49:12", "may/01 16:23:50" or "12:02:23" for log number *323
	# :put [$epochTime [:log get *323 time]]

	:local ds
	:local ts
	if ([:len $1]=0) do={
		# Get "now time"
		:set ds [/system clock get date]
		:set ts [/system clock get time]
	} else={
	
    if ($1 ~ "^([a-z]{3}/[0-9]{2}(/[0-9]{4})\? )\?[0-9]{2}:[0-9]{2}:[0-9]{2}\$") do={

      if ($1 ~ "^[a-z]{3}/[0-9]{2}") do={

        :set ds "$[:pick $1 0 6]/$[:pick [/system clock get date] 7 11]"
        :set ts [:pick $1 7 15]

        if ($1 ~ "^[a-z]{3}/[0-9]{2}/[0-9]{4}") do={
          :set ds "$[:pick $1 0 11]"
          :set ts [:pick $1 12 20]
        }

      } else={
        # Use remote time and get date
        :set ds [/system clock get date]
        :set ts $1
      }

    } else={ :error "Unsupported input format" }

	}
	:local months
	:if ((([:pick $ds 9 11]-1)/4) != (([:pick $ds 9 11])/4)) do={

		:set months {"an"=0;"eb"=31;"ar"=60;"pr"=91;"ay"=121;"un"=152;"ul"=182;"ug"=213;"ep"=244;"ct"=274;"ov"=305;"ec"=335}
	} else={
		:set months {"an"=0;"eb"=31;"ar"=59;"pr"=90;"ay"=120;"un"=151;"ul"=181;"ug"=212;"ep"=243;"ct"=273;"ov"=304;"ec"=334}
	}
	:set ds (([:pick $ds 9 11]*365)+(([:pick $ds 9 11]-1)/4)+($months->[:pick $ds 1 3])+[:pick $ds 4 6])
	:set ts (([:pick $ts 0 2]*60*60)+([:pick $ts 3 5]*60)+[:pick $ts 6 8])

  :local gmtOffset [/system clock get gmt-offset]
  :if ($gmtOffset > 86400) do={ :set $gmtOffset ($gmtOffset - 4294967296) }

	:return ($ds*24*60*60 + $ts + 946684800 - $gmtOffset)
}
