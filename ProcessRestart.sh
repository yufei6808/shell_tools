#!/bin/bash
#杀死一个或者多个进程
@auth yufei


function KillProcess(){
        echo "+++++++++++++++++"
        persion=$1
        echo "persion:"$persion
        count=`ps -ef |grep $persion |grep -v grep | grep -v /root/shell/ProcessRestart.sh |wc -l`
        echo "count:"$count

        for ((i=1;i<=$count;i++));do
            echo "i:"$i
            pid=`ps -ef |grep $persion |grep -v grep | grep -v /root/shell/ProcessRestart.sh | awk '{print $2}' | sed -n "${i}p"`
            #kill -9 $pid
            echo "pid:"$pid
        done
        echo "+++++++++++++++++"
}

args=$#
if [ $args == 0 ];then
    echo "Error !!!"
    echo "Must one or more Process ."
fi

for arg in "$@";do
    persion=$arg
    KillProcess $persion
done
