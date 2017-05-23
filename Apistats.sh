#!/bin/bash
#接口监控
while true
do
url="http://10.10.10.22/index.html"
status=$(/usr/bin/curl -s --head "$url"| awk '/HTTP/ {print $2}')
if [ "$status" != "200" ]; then
  echo "bad"
  echo bad |mail -s '123123' 17756098506@189.cn 
else
echo "good"
fi
sleep 3
done
