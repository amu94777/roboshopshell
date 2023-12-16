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

echo -e "$Y ****************NOW I AM CONFIGURAING USER CONFIGURATION**********$N"

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "DISABLED NODEJS"

dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "ENABLED NODEJS:18"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "INSATELLED NODEJS"

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "USER ROBOSHOP ADDED"
else
    echo -e "$Y USER IS ALREADY CREATED:::::$N :::$R SKIPPING $N"
fi   

mkdir -p /app
VALIDATE $? "APP DIRECTORY IS CREATED"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE

cd /app 

unzip -o /tmp/user.zip 

cd /app 

npm install &>> $LOGFILE
VALIDATE $? "NPM DEPENDENCIES IS INSTALLED"

cp /home/centos/roboshopshell/user.service /etc/systemd/system/user.service &>> $LOGFILE
VALIDATE $? "COPIED USER SERVICE"

systemctl daemon-reload
VALIDATE $? "DEAMON RELOAD"

systemctl enable user 
VALIDATE $? "ENABLED USER"

systemctl start user
VALIDATE $? "STARTED USER"

cp /home/centos/roboshopshell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "copied mongo repo content"

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "INSTALLED MONGO CLIENT"

mongo --host mongo.jaya123.shop </app/schema/user.js &>> $LOGFILE
VALIDATE $? "DATA LOADED"


