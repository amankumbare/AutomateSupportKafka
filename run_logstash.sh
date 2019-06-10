#!/bin/bash

#red=`tput setaf 1`
#green=`tput setaf 2`
#reset=`tput sgr0`

export INPUTS="/InputData/$2/$1/*"
export SINCEDB="/etc/OutputData/$2/$1/sincedb$1"
export ParseFailure="/etc/OutputData/$2/$1/grok_failures$1.csv"
export LOGSTASHOUTPUT="/etc/OutputData/$2/$1/complete$1.csv"

#######
# runnign multiple logstash
#export LS_SETTINGS_DIR=/etc/OutputData/$2/$1/	
#export SERVICE_NAME=$2-$1
#export SERVICE_DESCRIPTION=$2-$1
#####

echo "Running Logstash for you now. Sit back and relax !!!"
/usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/logstash-$2-$1.conf --path.logs /etc/OutputData/$2/$1/ --path.data /etc/OutputData/$2/$1/ --debug -w 2 > /tmp/$1.logs 2>&1 &

#/usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/logstash-$1.conf --debug -w 10 > /tmp/$1.logs 2>&1 &

#/usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/logstash-$2-$1.conf --debug -w 10 > /tmp/$1.logs 2>&1 &
