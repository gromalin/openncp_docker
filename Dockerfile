FROM debian:jessie

RUN sed -i "s/httpredir.debian.org/mirrors.digitalocean.com/" /etc/apt/sources.list

RUN  apt-get clean && \ 
  apt-get update && \
  apt-get install -y \
  openjdk-7-jdk \ 
  tomcat7-admin \
  libmysql-java


RUN apt-get install -y debconf-utils \
  && echo mysql-server-5.5 mysql-server/root_password password f866945aa3ea9dc | debconf-set-selections \
  && echo mysql-server-5.5 mysql-server/root_password_again password f866945aa3ea9dc | debconf-set-selections \
  && apt-get install -y mysql-server-5.5 -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing 

RUN ln -s /usr/share/java/mysql-connector-java-5.1.39.jar /usr/share/tomcat7/lib/mysql-connector-java-5.1.39.jar

RUN ln -s /var/lib/tomcat7/common/ common && \
  ln -s /var/lib/tomcat7/server/ server && \ 
  ln -s /var/lib/tomcat7/shared/ shared

RUN apt-get install -y zip wget

# Install epsos-configuration.zip 

RUN wget https://openncp.atlassian.net/wiki/download/attachments/65142795/epsos-configuration.zip?api=v2

RUN unzip epsos-configuration.zip\?api\=v2 -d /opt

RUN rm  epsos-configuration.zip\?api\=v2

ENV EPSOS_PROPS_PATH /opt/epsos-configuration/
