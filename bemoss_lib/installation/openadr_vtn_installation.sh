#!/bin/bash

#__author__ =  "Avijit Saha"

#Install maven
sudo apt install maven

#Install Java 7 (Required by OpenADR VTN)
sudo add-apt-repository ppa:openjdk-r/ppa  
sudo apt-get update   
sudo apt-get install openjdk-7-jdk

#Check Java version and select Java 7 if multiple versions available
sudo update-alternatives --config javac
sudo update-alternatives --config java

#Create Directory and download repositories
mkdir -p ~/openadr
cd ~/openadr
git clone https://github.com/EnerNOC/oadr2-ven.git
git clone https://github.com/EnerNOC/oadr2-vtn-new.git

#Install Dependencies for OpenADR VTN:
# Install Erlang for RabbitMQ
wget http://packages.erlang-solutions.com/site/esl/esl-erlang/FLAVOUR_1_general/esl-erlang_20.2.2-1~ubuntu~xenial_amd64.deb
sudo apt install ./esl-erlang_20.2.2-1~ubuntu~xenial_amd64.deb
sudo rm esl-erlang_20.2.2-1~ubuntu~xenial_amd64.deb
#Install OpenADR VEN
cd oadr2-ven
mvn install -Dmaven.test.skip=true
#Install RabbitMQ Server
echo "deb https://dl.bintray.com/rabbitmq/debian xenial main" | sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list
wget -O- https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install rabbitmq-server

#Run OpenADR VTN
cd ~/openadr/oadr2-vtn-new
export MAVEN_OPTS="-Xmx1024m -XX:MaxPermSize=256"
mvn grails:run-app
#Now VTN web server can be reached at: http://localhost:8080/oadr2-vtn-groovy/
#For running on a network instead of localhost, use following command with your machine IP
#mvn grails:run-app -https -grails.server.host 192.168.1.100
#In this case VTN webserver can be reached at: http://192.168.1.100:8080/oadr2-vtn-groovy/
#In BEMOSS OpenADRAgent launch.json file, use this as VTN URL.
