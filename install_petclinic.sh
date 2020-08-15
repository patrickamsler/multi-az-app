#! /bin/bash

#install java
sudo yum -y update
sudo yum install java-1.8.0-openjdk

#start petclinic
sudo nohup java -jar spring-petclinic-2.3.1.BUILD-SNAPSHOT.jar