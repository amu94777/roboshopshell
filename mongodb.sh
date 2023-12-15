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

    echo -e "$Y ******MANGODB CONFIGURATION STARTS FROM HERE *****$N"

    cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
    VALIDATE $? "cpopied mongodb repo"

    dnf install mongodb-org -y &>> $LOGFILE
    VALIDATE $? "mongodb install"
    systemctl enable mongod
    VALIDATE $? "enabled mongodb"
    systemctl start mongod
    VALIDATE $? "started mongodb"
    sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf



