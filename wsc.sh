#!/bin/bash
set -e

# source /path/to/helper.sh
source helper.sh


if ! [ -z $1 ]; then
 case $1 in 
  '-h' | '--help')
    help-list
  ;;
  '-l' | '--link')
    if [ -z $2 ]; then
      echo "please argue file list."
    else
      hacked-check $2
    fi
  ;;
  '-d' | '--domain')
    web-checker $2
  ;;
  esac
else
  echo -e ""
  echo -e "..::[ welcome2 website checker ]::.."
  echo ""
  echo -e "--option:"
  echo -e "1. scan website"
  echo -e "2. list hacked website"
  echo -e "3. list down website"
  echo -e "4. reset log"
  echo -e "q. quit"
  echo -e "--ctrl+c to quit~"
  echo ""
  echo -ne "choise#::> "; read choise
  main () {
    choise=$1
    if [ -z $choise ]; then choise=9; fi
    case $choise in
    "1") hacked-check list.txt ;;
    "2") list-hacked ;;
    "3") list-down ;;
    "4") reset-weblog ;;
    "q" | "Q") 
      echo "tanks for using :> "
      echo "../kankuu\.."
      exit 
      ;;
    *)
      echo ""
      echo -e "choise right answer!"
      echo ""
      ;;
    esac
    echo -ne "-----!!choise#::_> "
    read choiseN; main $choiseN
  }

  main $choise
fi