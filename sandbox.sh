
Got an easy progress bar function that i wrote the other day:

#!/bin/bash
# 1. Create ProgressBar function
# 1.1 Input is currentState($1) and totalState($2)
function ProgressBar {
# Process data
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
# Build progressbar string lengths
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:                           
# 1.2.1.1 Progress : [########################################] 100%
printf "\rProgress : [${_fill// /\#}${_empty// /-}] ${_progress}%%"

}

# Variables
_start=1

# This accounts as the "totalState" variable for the ProgressBar function
_end=100

# Proof of concept
for number in $(seq ${_start} ${_end})
do
    echo $number
    # sleep 0.1
    # ProgressBar ${number} 100
done
printf '\nFinished!\n'

# ------------------------------------------------------------------------

source $(find . -name .env-telegram)

echo $TELEGRAM_BOT_TOKEN

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

telegram_authentication_token $TELEGRAM_BOT_TOKEN $TELEGRAM_CHAT_ID > /dev/null ; echo $?
