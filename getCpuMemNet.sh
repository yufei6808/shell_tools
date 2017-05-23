#!/bin/bash
#
#

if [ $# -lt 1 ]; then
    help
    exit
fi

pid=$1
interval=1
while true             
  do
    echo $(date +"%y-%m-%d %H:%M:%S")
    mem=`cat /proc/$pid/status|grep -e VmRSS|awk '{print$2$3}'`
    cpu=`top -n 1 -p $pid|tail -2|head -1|awk '{ssd=NF-4} {print $ssd}'`
    echo "Cpu:         " $cpu
    echo "Mem:         " $mem
    #cat /proc/$pid/status|grep -e SigQ >> /root/test.log
    lianjie=`netstat -tunp | grep $pid | wc -l`
    ES=`netstat -tunp | grep $pid | grep ES | wc -l`
    echo "Tcp+Udp:     " $lianjie
    echo "ESTABLISHED: " $ES
    echo $blank
    sleep $interval
done


