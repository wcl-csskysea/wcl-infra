#!/bin/bash

LOG=/var/log/zabbix/$(basename $0).log

# config
slack_url='https://hooks.slack.com/services/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'
slack_username='Zabbix'
channel="$1"
shift 1
title="$1"
shift 1
params="$@"
emoji=':smile:'
timeout="5"
cmd_curl="/usr/bin/curl"
color="good"

# Some logs
date >> $LOG
echo "channel: $channel" >> $LOG
echo "title: $title" >> $LOG
echo "params: $params" >> $LOG

if [ "${title:0:7}" == "PROBLEM" ]; then
  emoji=':scream:'
  color='danger'
fi

# set payload
payload="payload={ \
  \"channel\": \"${channel}\", \
  \"username\": \"${slack_username}\", \
  \"icon_emoji\": \"${emoji}\", \
  \"attachments\": [ \
    { \
      \"fallback\": \"Date / Time: ${datetime} - ${title}\", \
      \"title\": \"${title}\", \
      \"title_link\": \"${trigger_url}\", \
      \"color\": \"${color}\", \
      \"fields\": [ \
        { \
            \"title\": \"Params\", \
            \"value\": \"${params}\", \
            \"short\": true \
        } \
      ] \
    } \
  ] \
}"

# send to slack
echo "$payload" >> $LOG
${cmd_curl} -m ${timeout} --data-urlencode "${payload}" "${slack_url}" >> $LOG 2>&1
if [ $? -eq 0 ]; then 
  echo "SUCCESS" >> $LOG
else
  echo "ERROR" >> $LOG
fi