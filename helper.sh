#!/bin/bash
set -e

# function
curl-checker () {
  if [ $(which curl > /dev/null 2>&1; echo $?) -gt 0 ]; then
    echo -e "Error : package curl needed, try to install curl package."
    exit
  else
    echo -e "[*] curl detected!"
  fi
}

web-checker () {
  domain=$1
  echo "------------------------------------------------------------------"
  if [ -z $domain ]; then
    echo -e "./check [domain]"
  else
    echo -e "[*] CHECKING DOMAIN [$domain]"
    alive-check $domain
    if [ $(
        curl -s $domain | grep -e hack -e Hack -e hAck -e haCk -e \
        hacK -e HAck -e HaCk -e HacK -e HaCK -e hACk -e hAcK -e \
        haCK -e h4ck -e H4ck -e h4ck -e h4Ck -e h4cK -e H4ck -e \
        H4Ck -e H4cK -e H4CK -e h4Ck -e h4cK -e h4CK > /dev/null \
        2>&1 ; echo $?) -eq 0 ]
      then
      echo -e "[*] website $domain is - [HACKED]"
    elif [ $(curl -s $domain | grep suspend > /dev/null ; echo $? ) -eq 0 ];
      then
      echo -e "[!] website $domain is - [SUSPENDED]"
    else
      echo -e "[*] website $domain is - [SAFE]"
    fi
  fi
  echo "------------------------------------------------------------------"
}

alive-check () {
  domain=$1
  status=$(ping -w 1 $domain > /dev/null 2>&1; echo $?)
  if [ $status -gt 0 ]; then
    echo -e "[*] $domain is - [DOWN]"
  else
    echo -e "[*] server is - [UP]"
  fi
}

hacked-check () {
  curl-checker
  list=$(cat $1)
  echo -e "--#PROGRESS:-Domain:SCANNING..."
  for i in $list; do
    web-checker $i >> web.log
    echo -n "#"
  done
  echo ""
  echo -e "[*] SCANNING COMPLETE!"
  echo ""
}

reset-weblog () {
  echo -e "---reseting web.log"
  echo "" > web.log
  echo -e "[*] reseting [COMPLETE]"
}

list-hacked () {
  echo -e "-----LIST WEBSITE IDENTIFY AS HACKED"
  hacked=$(cat web.log | grep HACKED)
  echo $hacked
}

list-down () {
  echo -e "-----LIST WEBSITE IS DOWN"
  down=$(cat web.log | grep DOWN)
  echo $down
}

help-list () {
  echo ""
  echo "///website checker///"
  echo ""
  echo "COMMAND [OPTION] [abcdefgABCD123~!##] argument"
  echo ""
  echo "OPTION:"
  echo -e "\t-h --help \t\t show help commands"
  echo -e "\t-l --link [links] \t insert external links"
  echo ""
}