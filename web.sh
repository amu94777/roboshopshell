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

echo -e "$Y*******WEB CONFIGURATION*********$N"

dnf install nginx -y &>> $LOGFILE
VALIDATE $? "INSTALLED NGINX"

systemctl enable nginx
VALIDATE $? "ENABLED NGINX"

systemctl start nginx
VALIDATE $? "STARTED NGINX"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "REMOVEING DEFAULT CONTENT"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip
VALIDATE $? "CONTENT DOWNLOADED"

cd /usr/share/nginx/html

unzip /tmp/web.zip &>> $LOGFILE
VALIDATE $? "UNZIPPING FILE CONTENT"

cp /home/centos/roboshopshell/roboshop.conf /etc/nginx/default.d/roboshop.conf 
VALIDATE $? "COPIED ROBOSHOP CONFIG"

systemctl restart nginx 
VALIDATE $? "RESTARED NGINX"