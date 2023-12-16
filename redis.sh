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

echo -e "$R***** CONFIGURING REDIS*******$N"

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE
VALIDATE $? "RPM REPO FILE "

dnf module enable redis:remi-6.2 -y &>> $LOGFILE
VALIDATE $? "ENABLED RPM REPO"

dnf install redis -y &>> $LOGFILE
VALIDATE $? "INSTALLED REDIAS"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf
VALIDATE $? "CHANGING PORT"

systemctl enable redis
VALIDATE $? "ENABLED REDIS"

systemctl start redis
VALIDATE $? "STARTED REDIS"