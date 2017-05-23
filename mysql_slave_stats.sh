
#!/bin/bash
host=111
port=3308
pass=xxx
LOG=/data/logs/mysql_status.log
b=0

while [ true ]
    do
    DATE=`date "+%Y-%m-%d %H:%M:%S"`
    #检查同步正常否
    mysql -uroot -p$pass -h$host -P$port -e "show slave status\G;" | grep -i Running | egrep "IO|SQL" | grep -i yes | wc -l > /data/logs/status.log
    #监控主从延时时间
    mysql -uroot -p$pass -h$host -P$port -e "show slave status\G;" | grep -i Seconds_Behind_Master | awk -F: '{print$2}' >> /data/logs/status_time.log
    echo $DATE >> /data/logs/status_time.log

    sleep 20
    [ $(cat /data/logs/status.log) -eq 2 ] > /dev/null
    a=$?
    if [ $a -ne 0 ]
        then
        if [ $a -ne $b ]
            then
            b=$a
            echo '-------------------------------------------------' >> $LOG  &&
            date >> $LOG
            echo "警报：mysql同步中断！！IP:$Server Time:$DATE" | mail -s "警告: mysql同步中断" $Mail
            echo "警报：mysql同步中断！！IP:$Server Time:$DATE" | mail -s "警告: mysql同步中断" kq953k@163.com
            curl -s -v -k -X POST "http://www.goodid.com/api/sendMessage" -d "..." &&
            echo "mysql-slave failed " >> $LOG
        fi
    else
        if [ $a -ne $b ]
            then
            b=$a
            echo '-------------------------------------------------' >> $LOG  &&
            date >> $LOG
            echo "通知：mysql同步恢复正常！！IP:$Server Time:$DATE" | mail -s "通知: mysql同步恢复正常" $Mail
            echo "通知：mysql同步恢复正常！！IP:$Server Time:$DATE" | mail -s "通知: mysql同步恢复正常" kq953k@163.com
            curl -s -v -k -X POST "http://www.goodid.com/api/sendMessage" -d "..." &&
            echo "mysql-slave Resume normal " >> $LOG
        fi
    fi
done

