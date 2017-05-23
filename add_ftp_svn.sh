启动添加ftp
# * 自动增加ftp账号 后面跟用户名和密码
# * @copyright(c) 2005-2017 www.antuan.com
# * @version Id:1 
# * @author: yufei
#/bin/sh
#自动增加ftp账号 后面跟用户名和密码
if [ $# -lt 2 ]; then
    echo "error.. need directory password"
    exit 1
fi

mkdir /data/html/$1
useradd -s /sbin/nologin -d /data/html/$1/ $1 -g www
echo $2 | passwd --stdin $1
chmod -Rf 775 /data/html/$1
chown -Rf www:www /data/html/$1
echo $1 >> /etc/vsftpd/chroot_list
/etc/init.d/vsftpd restart



自动添加svn
#!/bin/sh
# * 自动增加svn账号 后面跟用户名和密码
# * @copyright(c) 2005-2017 www.antuan.com
# * @version Id:1 
# * @author: yufei

if [ $# -lt 1 ]; then
    echo "error.. need directory"
    exit 1
fi

mkdir /data/html/$1
chown -Rf www:www /data/html/$1
mkdir /data/svn/www/$1
/data/svn/bin/svnadmin create /data/svn/www/$1
echo "[general]" > /data/svn/www/$1/conf/svnserve.conf
echo "anon-access = none" >> /data/svn/www/$1/conf/svnserve.conf
echo "auth-access = write" >> /data/svn/www/$1/conf/svnserve.conf
echo "password-db = /data/svn/passwd" >> /data/svn/www/$1/conf/svnserve.conf
echo "authz-db = /data/svn/authz" >> /data/svn/www/$1/conf/svnserve.conf
echo "realm = $1" >> /data/svn/www/$1/conf/svnserve.conf

echo " " >> /data/svn/authz
echo "[$1:/]" >> /data/svn/authz
echo "@admin=rw" >> /data/svn/authz
echo "@wk=rw" >> /data/svn/authz
echo "*=" >> /data/svn/authz

echo "#!/bin/sh" > /data/svn/www/$1/hooks/post-commit
echo "export LANG=zh_CN.UTF-8" >> /data/svn/www/$1/hooks/post-commit
echo " REPOS=\"\$1\"" >> /data/svn/www/$1/hooks/post-commit
echo " REV=\"\$2\"" >> /data/svn/www/$1/hooks/post-commit
echo " /data/svn/bin/svn update /data/html/"$1"/ --username jy --password jy127" >> /data/svn/www/$1/hooks/post-commit
echo " /bin/chown -Rf www.www /data/html/"$1"/" >> /data/svn/www/$1/hooks/post-commit
echo " /bin/chmod -Rf 775 /data/html/"$1"/" >> /data/svn/www/$1/hooks/post-commit
chmod +x /data/svn/www/$1/hooks/post-commit

killall svnserve
/data/svn/bin/svnserve -d -r /data/svn/www



钩子
#!/bin/sh
export LANG=zh_CN.UTF-8
REPOS="$1"
REV="$2"
/data/svn/bin/svn update /data/html/aaa/ --username jy --password jy127


钩子
# vim /data/svn/test.ttlsa.com/hooks/post-commit
#!/bin/bash
# DateTime:2013-05-16 14:58:33
# AuthorName: Deng Yun
# description：用于实时检出的钩子

# 基本变量
export LANG=en_US.UTF-8
dateTime=`date +%F`
dateTimeMinute=`date +%H%M%S`
binSvn=/usr/local/subversion-1.8.5/bin/svn # 你svn的绝对路径
dirHtmlApp=/data/site/test.ttlsa.com #检出的web站点根目录
logFileName=/tmp/svnhooks_${dateTime}.log

# svn配置
REPOS="$1"
REV="$2"

# 检出或者更新subversion，钩子的核心功能
echo  "-- $dateTimeMinute" >> $logFileName
if [ ! -d $dirHtmlApp/.svn ]; then
   # 检出SVN
   echo "$binSvn co file://$REPOS/  $dirHtmlApp" >> $logFileName
   $binSvn co file://$REPOS/  $dirHtmlApp
   if [ $? -eq 0 ]; then
      echo  "checkout ok"  >> $logFileName
   else
      echo  "checkout error"   >>  $logFileName
   fi
else
   # 更新svn
   echo " $binSvn up $REV $dirHtmlApp " >> $logFileName
   $binSvn up $REV $dirHtmlApp   >> $logFileName
   if [ $? -eq 0 ]; then
       echo  "  update sucess "  >> $logFileName
   else
       echo  "  update fial "   >>  $logFileName
   fi
fi
echo  "--" >>  $logFileName
