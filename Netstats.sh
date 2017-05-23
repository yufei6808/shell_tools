

#!/bin/bash

DATE=`date "+%Y-%m-%d %H:%M:%S"`
Server=114.113.157.84
Mail=17756098506@189.cn
LOG=/root/ping.log
b=0

while [ true ]
        do
                [ `ping -w 3 $Server | grep 'time=' | wc -l` -ge 1 ] > /dev/null
                a=$?
                if [ $a -ne 0 ]
                        then
                        if [ $a -ne $b ]
                                then
                                b=$a
                                date >> $LOG
                                echo "$Server 路由表：" >> $LOG
                                traceroute -n -m 30 $Server >> $LOG  &&
                                echo '-------------------------------------------------' >> $LOG  &&
                                echo '' >> $LOG  &&
                                echo '' >> $LOG  &&
                                tail -30 $LOG > /root/ping.txt
                                echo "警报：机房网络中断！！IP:$Server Time:$DATE" | mail -s "警告: 铜牛机房网络中断" $Mail

                        fi
                else
                        if [ $a -ne $b ]
                                then
                                b=$a
                                date >> $LOG
                                echo "$Server 路由表：" >> $LOG
                                traceroute -n -m 30 $Server >> $LOG  &&
                                echo '-------------------------------------------------' >> $LOG  &&
                                echo '' >> $LOG  &&
                                echo '' >> $LOG  &&
                                tail -30 $LOG > /root/ping.txt
                                echo "通知：机房网络恢复正常！！IP:$Server Time:$DATE" | mail -s "通知: 铜牛机房网络正常" $Mail

                         fi
               fi
done


#!/bin/bash
#
#网络质量监控
#
DATE=$(date -d today +"%Y-%m-%d %H:%M:%S")

ping -c 5 114.114.114.114 | awk '{print$7}' > /tmp/ping.log
cat /tmp/ping.log | grep time | awk -F= '{print$2}'> /tmp/time.log

while read line
do
    if [ $(echo "$line > 100" | bc) = 1 ]
        then
        echo "ping 114.114.114.114" "time="$line $DATE >> /data/logs/ping.log
    fi

done < '/tmp/time.log';