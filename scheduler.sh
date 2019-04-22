# this is a sample conjob runner
# if you want to use website checker script with cronjob
# you can use this scheduler.sh script
#
# example usage : in cronjob
# 
# -> 0 6,18 * * * /path/to/scheduler.sh /path/to/helper.sh /path/to/.env.telegram /path/to/domain.list /path/to/logs/output.log
#
# ----------------------------------

helper=$1
telegram_env=$2
website_list=$3
output_path=$4

source $helper
source $telegram_env
hacked-check $website_list $output_path
send_notif