#!/bin/bash
set -e

# sources ----------------------
source $(find . -name .env-telegram)

# function ---------------------

telegram_authentication_token () {
    # $1 TELEGRAM_BOT_TOKEN
    # $2 TELEGRAM_CHAT_ID
    if [ -z $1 ] || [ -z $2 ]; then
        echo ""
        echo "ERR : telegram environment is not valid, please check environment variable bellow :"
        echo "----> cat .env-telegram :"
        echo ""
        cat $(find . -name .env-telegram)
    fi
    if [ -z $1 ]; then
        echo "DETECT_ERR : TELEGRAM_BOT_TOKEN is EMPTY!"
        return 1; exit
    elif [ -z $2 ]; then
        echo "DETECT_ERR : TELEGRAM_CHAT_ID is EMPTY!"
        return 1; exit
    fi
    echo ""
    return 0
}

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
        H4Ck -e H4cK -e H4CK -e h4Ck -e h4cK -e h4CK -e attack -e \
        ATTACK -e Attack -e 4tt4ck > /dev/null \
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
  if [ $(uname -a | grep Linux > /dev/null ; echo $?) -eq 0 ]; then
    status=$(ping -w 1 $domain > /dev/null 2>&1; echo $?)
  elif [ $(uname -a | grep Mac > /dev/null ; echo $?) -eq 0 ]; then
    status=$(ping -t 1 $domain > /dev/null 2>&1; echo $?)
  fi

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
    web-checker $i >> logs/$(date +%Y-%m-%d)-web.log
    echo -n "#"
  done
  echo ""
  echo -e "[*] SCANNING COMPLETE!"
  echo ""
}

reset-weblog () {
  echo -e "---reseting web.log"
  mv logs/$(date +%Y-%m-%d)-web.log logs/$(date +%Y-%m-%d)-web.log-bak
  echo -e "[*] reseting [COMPLETE]"
}

list-hacked () {
  echo -e "-----LIST WEBSITE IDENTIFY AS HACKED"
  cat web.log | grep HACKED
}

list-down () {
  echo -e "-----LIST WEBSITE IS DOWN"
  cat web.log | grep DOWN
}

help-list () {
  echo ""
  echo "///website checker///"
  echo ""
  echo "COMMAND [OPTION] argument"
  echo ""
  echo "OPTION:"
  echo -e "\t-h --help \t\t show help commands"
  echo -e "\t-l --list [list] \t insert external links. like example list.txt"
  echo -e "\t-d --domain [domain] \t scanning specified domain"
  echo ""
}