#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
MONGODB-HOST="mongo.jaya123.shop"
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

    echo -e "$G*******NOW I AM DOING CATALOGUE CONFOGURATION*********$N"


dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "DISABLE NODEJS"

dnf module enable nodejs:18 -y &>> LOGFILE
VALIDATE $? "ENABLED NODEJS:18"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "INSTALLED NODEJS"

id roboshop
if [ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "ADDED USER"
else
    echo "ROBOSHOPUSER IS ALREADY THERE" 
 fi      

mkdir -p /app
VALIDATE $? "APP DIRECTORY CREATION"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

cd /app 

unzip -o /tmp/catalogue.zip 
cd /app

npm install &>> $LOGFILE
VALIDATE $? "NPM INSTALLED"

cp /home/centos/roboshopshell/catalog.service /etc/systemd/system/catalog.service
VALIDATE $? "COPIED CATALOG.SERVICE"

systemctl daemon-reload
VALIDATE $? "DEAMON-RELOAD"

systemctl enable catalogue
VALIDATE $? "ENABLED CATALOG"

systemctl start catalogue
VALIDATE $? "STARTED CATALOG SERVICE"

cp /home/centos/roboshopshell/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "COPIED MONGO REPO"

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "INSATLLED MONGO CLIENT"

mongo --host $MONGODB-HOST </app/schema/catalogue.js
VALIDATE $? "LOADING CATALOG DATA INTO MONGO DB"

