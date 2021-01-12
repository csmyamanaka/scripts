#!/bin/sh

## System Resource Monitor Script
## "resmon.sh"
## M. Yamanaka
## email: myamanaka@live.com
## website: csmyamanaka.com
## license: MIT (See included "LICENSE" file for detais)

#Prints information of interest regarding a user's system


##
## Information
##

VOLTEXT="volume"
VOLSTAT=$(pactl list sinks | grep "Volume: front-left:" | awk '{print $5}')

MEMTEXT="RAM"
MEMSTAT=$(free -h | grep "Mem:" | awk '{print $3" / "$2}')

BATTEXT="battery"
BATINFO=/sys/class/power_supply/BAT1
BATSTAT="$(( $(cat $BATINFO/charge_now)*100/$(cat $BATINFO/charge_full) )) ($(cat $BATINFO/status))"

CLKTEXT="time"
CLKSTAT=$(date +"%T %Y-%b-%d")

##
## Print formatting
##

#print order
#default order is volume, RAM, battery, time
PRTORDER="vrbt"

DELIM="|"

#change order according to user input
if [ "$1" != "" ]
then
  PRTORDER=$1
fi

#return string
PRTSTRING=""

#keep track of original order
ORGORDER=$PRTORDER

while [ "$PRTORDER" != "" ]
do
  #get the first character
  CRTOBJ=$(echo $PRTORDER | cut -b 1)
  CRTSTRING=""
  case $CRTOBJ in
    "v") CRTSTRING="$VOLTEXT: $VOLSTAT" ;;
    "t") CRTSTRING="$CLKTEXT: $CLKSTAT" ;;
    "b") CRTSTRING="$BATTEXT: $BATSTAT" ;;
    "r") CRTSTRING="$MEMTEXT: $MEMSTAT" ;;
    *)
      echo "bad!"
      exit 1
      ;;
  esac
  
  #on first run, don't print the delimiter
  if [ "$PRTORDER" = "$ORGORDER" ]
  then
    PRTSTRING="$CRTSTRING"
  else
    PRTSTRING="$PRTSTRING $DELIM $CRTSTRING"
  fi

  #remove the first character
  PRTORDER=$(echo $PRTORDER | sed "s/^.//g")
done

echo $PRTSTRING
