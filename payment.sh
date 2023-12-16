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

echo -e "$R *****CONFIGUREING PAYMENT CONFIGURATION******$N"

dnf install python36 gcc python3-devel -y &>> $LOGFILE
VALIDATE $? "INSTALLED PYTHON36 GCC"

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "ROBOSHOP USER CREATION"
else
    echo "USER IS ALREADY THERE $R SKIPPING $N"
fi

mkdir -p /app 
VALIDATE $? "APP DIRECTORY CREATION"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip
VALIDATE $? "APPLICATION CADE DOWNLOADED"

cd /app 

unzip -o /tmp/payment.zip &>> $LOGFILE
VALIDATE $? "UNZIPPED FILE CONTENT"

cd /app 

pip3.6 install -r requirements.txt &>> $LOGFILE
VALIDATE $? "INSTALLED DEPENDENCIES"

cp /home/centos/roboshopshell/payment.service /etc/systemd/system/payment.service
VALIDATE $? "COPIED PAYMENT.SERVICE"

systemctl daemon-reload
VALIDATE $? "RELODED DEMON"

systemctl enable payment 
VALIDATE $? "ENABLED PAYMENT"

systemctl start payment
VALIDATE $? "STARTED PAYMENT"
