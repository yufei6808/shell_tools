#shell登录报警

#!/bin/sh
#by yufei 2014-12-19
#for antuan

if [ $# -lt 1 ]; then
    who=`who am i| awk '{print$1$5}'`
else
    who=$1`who am i| awk '{print$5}'`
fi

ip=`who am i| awk '{print$5}'`
LOG="/data/tmp/login.log"
host="101.200.55.179ddsql"
DATE=$(date +'%Y-%m-%d.%H:%M:%S')
service="${who}登录了"
phone="177......"

function Fail(){
    local host=$1
    local service=$2
    local DATE=$3
    local phone=$4
    curl -s -v -k -X POST "......" &&
    date >> $LOG
    echo `who am i` "loging" >> $LOG
    echo $service $DATE >> $LOG
    echo '-------------------------------------------------' >> $LOG  &&
    echo '' >> $LOG
}

Fail $host $service $DATE $phone


if [ $ip == "(117.71.48.4)" ];then
   date >> $LOG
   echo `who am i` "loging" >> $LOG
   echo $service $DATE >> $LOG
   echo '-------------------------------------------------' >> $LOG  &&
   echo '' >> $LOG
   exit
else
   Fail $host $service $DATE $phone
fi


#vim /root/.bashrc添加
sh /data/tmp/login.sh root

