FROM debian:jessie

RUN sed -i "s/httpredir.debian.org/mirrors.digitalocean.com/" /etc/apt/sources.list

RUN  apt-get clean && \ 
  apt-get update && \
  apt-get install -y \
  openjdk-7-jdk \ 
  tomcat7-admin \
  libmysql-java \
  tomcat7


RUN apt-get install -y debconf-utils \
  && echo mysql-server-5.5 mysql-server/root_password password f866945aa3ea9dc | debconf-set-selections \
  && echo mysql-server-5.5 mysql-server/root_password_again password f866945aa3ea9dc | debconf-set-selections \
  && apt-get install -y mysql-server-5.5 -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing 

RUN ln -s /usr/share/java/mysql-connector-java-5.1.39.jar /usr/share/tomcat7/lib/mysql-connector-java-5.1.39.jar

RUN ln -s /var/lib/tomcat7/common/ /usr/share/tomcat7/common && \
  ln -s /var/lib/tomcat7/server/ /usr/share/tomcat7/server && \ 
  ln -s /var/lib/tomcat7/shared/ /usr/share/tomcat7/shared && \
  ln -s /var/lib/tomcat7/conf/ /usr/share/tomcat7/conf

RUN apt-get install -y zip wget

# Install epsos-configuration.zip 

RUN wget https://openncp.atlassian.net/wiki/download/attachments/65142795/epsos-configuration.zip?api=v2

RUN unzip epsos-configuration.zip\?api\=v2 -d /opt

RUN rm  epsos-configuration.zip\?api\=v2

ENV EPSOS_PROPS_PATH /opt/epsos-configuration/

WORKDIR /opt/epsos-configuration/

ADD ./configmanager.hibernate.xml  /opt/epsos-configuration/

RUN mkdir -p $EPSOS_PROPS_PATH/cert/PPT/conf

WORKDIR /opt/epsos-configuration/cert/PPT/

ADD ./cacert.sh /opt/epsos-configuration/cert/PPT/

ADD ./startup.sh /opt/startup.sh

ADD conf/* /opt/epsos-configuration/cert/PPT/conf/

ADD selfcert.sh /opt/epsos-configuration/cert/PPT/

#ADD server.xml /etc/tomcat7

EXPOSE 8080

CMD ["/bin/bash", "/opt/startup.sh"]
