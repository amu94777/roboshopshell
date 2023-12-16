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

echo -e "$R******** CONFIGURING RABBITMQ********$N"

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE
VALIDATE $? "CONF YUM REPOS BY SCRIPT"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE
VALIDATE $? "CONF YUM REPOS FOR RABBITMQPACKAGE"

dnf install rabbitmq-server -y &>> $LOGFILE
VALIDATE $? "INSATLLED RABBITMQ SERVER"

systemctl enable rabbitmq-server 
VALIDATE $? "ENABLED RABITMQ SERVER"

systemctl start rabbitmq-server 
VALIDATE $? "STARTED RABITMQ SERVER"

rabbitmqctl add_user roboshop roboshop123

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
