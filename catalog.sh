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

    echo -e "$G*******NOW I AM DOING CATALOGUE CONFOGURATION*********$N"


dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "DISABLE NODEJS"

dnf module enable nodejs:18 -y &>> LOGFILE
VALIDATE $? "ENABLED NODEJS:18"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "INSTALLED NODEJS"

useradd roboshop
VALIDATE $? "ADDED USER"

mkdir /app
VALIDATE $? "APP DIRECTORY CREATION"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip



