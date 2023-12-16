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

echo -e "$G ******NOW I AM DOING SHIPPING CONFIGURTION********$N"

dnf install maven -y &>> $LOGFILE
VALIDATE $? "MAVEN INSTALLTION"

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "ROBOSHOPUSER ADDED"
else
    echo "ROBOSHOP USER IS ALREADY IS CREATED:::::$R SKIPPING $N"
fi

mkdir /app
VALIDATE $? "APP DIRECTORY CREATION"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE
VALIDATE $? "APPLICATION CODE COPIED"

cd /app

unzip /tmp/shipping.zip &>> $LOGFILE
VALIDATE $? "UNZIPFILE CONTENT"

cd /app

mvn clean package &>> $LOGFILE
VALIDATE $? "MAVEN CLEAN PACKAGE"

mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE
VALIDATE $? "JAR FILE MOVED"