#!/bin/bash

sudo yum update -y
sudo yum install ruby -y
sudo yum install wget -y
CODEDEPLOY_BIN="/opt/codedeploy-agent/bin/codedeploy-agent"
$CODEDEPLOY_BIN stop
yum erase codedeploy-agent -y
cd /home/ec2-user
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
./install auto
sudo service codedeploy-agent start
#udo amazon-linux-extras install nginx1 -y
sudo yum install httpd -y
sudo service httpd start
sudo mv /usr/share/httpd/noindex/index.html /var/www/html/
