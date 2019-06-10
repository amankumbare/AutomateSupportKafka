#!/bin/bash

#Setting colors for echo statements  
#red=`tput setaf 1`
#green=`tput setaf 2`
#reset=`tput sgr0`

DATE=`date "+%Y%m%d-%s"`

# Reading caseno and component name from user | In Future this would be replaced by inputs which user will enter from webapp
#read -p "Enter your case number :" caseno
#read -p "Enter your component :" component
echo -e "Case Number you have entered is: $1 $2 \n"

#  Exporting env variables | Delet once testing is done.
#echo -e " EXPORTING ENV VARIABLES $1 \n"

export INPUTS="/InputData/$2/$1/*"
export SINCEDB="/etc/OutputData/$2/$1/sincedb$1"
export ParseFailure="/etc/OutputData/$2/$1/grok_failures$1.csv"
export LOGSTASHOUTPUT="/etc/OutputData/$2/$1/complete$1.csv"


# Creating Input directories
mkdir -p /InputData/$2/$1
echo -e "Input Data is copied to /InputData/$2/$1 \n"

# Creating Output directories
mkdir -p /etc/OutputData/$2/$1
echo -e "Output of logstash is stored in /etc/OutputData/$2/$1 \n"

########
#changes to run multiple logsstash
#touch /etc/OutputData/$2/$1/logstash.yml
#echo "path.data: /etc/OutputData/$2/$1/" > /etc/OutputData/$2/$1/logstash.yml
#echo "path.logs: /etc/OutputData/$2/$1/" >> /etc/OutputData/$2/$1/logstash.yml
#echo "node.name: $2-node-$1/" >> /etc/OutputData/$2/$1/logstash.yml
#echo "config.reload.automatic: true" >> /etc/OutputData/$2/$1/logstash.yml

#cp /root/logstashconfigs/startup.options-template /etc/OutputData/$2/$1/startup.options 
#######

# Creating SinceDB file which is important to compare if parsing is completed or not !!
touch /etc/OutputData/$2/$1/sincedb$1

# Creating grok faliure file which can be used to check which logs did'nt matched any patterns !!!
touch /etc/OutputData/$2/$1/grok_failures$1.csv

# Creating complete file which would be used as an inout to java programe
touch /etc/OutputData/$2/$1/complete$1.csv

# In previous version sed was used to create a temple of logstash configs which is now replaced environment variable.

#echo -e "Creating a template of logstash config for $1 : /etc/logstash/conf.d/logstash-$1.conf \n"
#sed 's+/InputData/test/+/InputData/'$1'/+g; s+/tmp/sincedb+/etc/OutputData/'$1'/sincedb'$1'+g; s+/tmp/grok_failures.csv+/etc/OutputData/'$1'/grok_failures'$1'.csv+g; s+/etc/logstash/complete.csv+/etc/OutputData/'$1'/complete'$1'.csv+g; s+/etc/logstash/exceptiontg.csv+/etc/OutputData/'$1'/exceptiontg'$1'.csv+g ; s+/etc/logstash/errortg.csv+/etc/OutputData/'$1'/errortg'$1'.csv+g' /root/logstashconfigs/logstash-filter-file-template.conf > /etc/logstash/conf.d/logstash-$1.conf

# Copying logstash config file, run_logstash.sh script will use below path.
cp /root/logstashconfigs/logstash-filter-file-template.conf /etc/logstash/conf.d/logstash-$2-$1.conf

echo -e "Copying data manually \n"
cp -r $3/* /InputData/$2/$1/
#cp /var/log/no.txt /InputData/$1/
#cp /var/log/finaltest/a26.log /InputData/$2/$1/

# To remove unwanted logs from input files along with lines which start with 'at'.
for f in /InputData/$2/$1/*  ; do sed -i '/^\s\+\(at\|\.\.\.\)\s/d ; /INFO/d ; /TRACE/d' "$f" ; done

# Store the sum of all bytes in input dir
sum=`ls -li /InputData/$2/$1/* | grep -v /InputData/$2/$1/*.zip | grep -v /InputData/$2/$1/*.tar.gz | grep -v /InputData/$2/$1/*.tar | grep -v /InputData/$2/$1/*.tbz | grep -v /InputData/$2/$1/*.tgz | grep -v /InputData/$2/$1/*.bz2 | grep -v /InputData/$2/$1/*.sh  | grep -v /InputData/$2/$1/*.py | awk -F ' ' '{sum+=$6}END{print sum;}'`

echo -e "Sum of input file size in bytes is $sum $ \n"


# Runninfg Logstash script /root/run_logstash.sh 
/root/run_logstash.sh $1 $2

PID=`ps -aef |grep -i 'logstash-'$2'-'$1'.conf' | grep -v grep | awk -F ' ' '{print $2}'`
#echo  -e "Your logstash process ID is $PID \n"
#ps -aef | grep -i 'logstash-'$1'.conf'

#To check sum of bytes in sincedb
#cat /etc/OutputData/$1/sincedb$1 | awk -F ' ' '{sum+=$4}END{print sum;}'

sleep 5

# Initializing x
x=0

# Storing null value in x
#x=`cat /tmp/sincedb$1 | awk -F ' ' '{sum+=$4}END{print sum;}'`

#echo $x

#Comparing total value of sincedb offset with sum(sum of allbytes of inputdata)
while [ $x -lt $sum ]
do
 x=`cat /etc/OutputData/$2/$1/sincedb$1 | awk -F ' ' '{sum+=$4}END{print sum;}'`
  if [ -z "$x" ];
  then
  {
#	echo " Varible X is empty"
	x=0
  }
  elif [ $x -eq $sum ];
  then
  {
	echo -e "Logstash parsing is completed, parsed $x bytes \n"
	kill -15 "$PID"
  }
  else
  {
	echo "Parsing is not competed yet"
  }
  fi
  sleep 10
 #echo $x
done

echo  -e "Finding recommendations for you \n"

# Running Java program :
java -Dlogfile=/etc/OutputData/$2/$1/missingsolutions.log -cp /root/java/kafkajar/log4j-1.2.17.jar:/root/java/kafkajar/kafkadev-3.0-POC.jar  com.hwx.LogProcessor /root/java/kafkajar/kafkasolutions.csv /etc/OutputData/$2/$1/complete$1.csv

tar -czf /TarBalls/$1-$DATE.tar.gz /etc/OutputData/$2/$1/* /tmp/$1.logs /InputData/$2/$1/* /etc/logstash/conf.d/logstash-$2-$1.conf /var/log/$1/*

rm -rf /etc/OutputData/$2/$1 /tmp/$1.logs /InputData/$2/$1 /etc/logstash/conf.d/logstash-$2-$1.conf /var/log/$1

