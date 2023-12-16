#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
VALIDATE(){
 if [ $1 -ne 0 ] 
 then
    echo -e "$R ERROR ::::::$2 FAILED $N"
    exit 1
 else
    echo -e "$G $2 is successfull $N"
fi         
}
if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:::you are not a root user $N"
    exit 1
else
    echo -e "$G you are a root user $N"
fi

echo -e "$R *****CONFIGURING MYSQL CONFOGURATION*******$N"

dnf module disable mysql -y &>> $LOGFILE
VALIDATE $? "DISABLED MYSQL"

cp /home/centos/roboshopshell/mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE
VALIDATE $? "MYSQL REPO COPIED"

dnf install mysql-community-server -y &>> $LOGFILE
VALIDATE $? "INSTALLED MYSQLCOMMUNITY SERVER"

systemctl enable mysqld
VALIDATE $? "ENABLED MYSQLD"

systemctl start mysqld
VALIDATE $? "STARTED MYSQLD"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "SET PASSWD"

mysql -uroot -pRoboShop@1
VALIDATED $? "CHECKING PASSWD"


