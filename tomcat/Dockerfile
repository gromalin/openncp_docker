FROM debian:jessie

RUN sed -i "s/httpredir.debian.org/mirrors.digitalocean.com/" /etc/apt/sources.list

RUN  apt-get clean && \ 
  apt-get update && \
  apt-get install -y \
  openjdk-7-jdk \ 
  tomcat7-admin \
  libmysql-java \
  mysql-client \
  tomcat7 \
  vim 

RUN ln -s /usr/share/java/mysql-connector-java-5.1.39.jar /usr/share/tomcat7/lib/mysql-connector-java-5.1.39.jar

RUN mkdir /var/lib/tomcat7/temp

RUN ln -s /var/lib/tomcat7/common/ /usr/share/tomcat7/common && \
  ln -s /var/lib/tomcat7/server/ /usr/share/tomcat7/server && \
  ln -s /var/lib/tomcat7/shared/ /usr/share/tomcat7/shared && \
  ln -s /var/lib/tomcat7/conf/ /usr/share/tomcat7/conf && \
  ln -s /var/lib/tomcat7/temp/ /usr/share/tomcat7/temp


# Install epsos-configuration.zip 

ADD ./epsos-configuration /opt/epsos-configuration_tmp

ENV EPSOS_PROPS_PATH /opt/epsos-configuration_tmp/

ADD ./configmanager.hibernate.xml  /opt/epsos-configuration_tmp/

#RUN mkdir -p $EPSOS_PROPS_PATH/cert/PPT/conf

#WORKDIR /opt/epsos-configuration/cert/PPT/

#VOLUME /opt/epsos-configuration/cert/PPT/

ADD ./cacert.sh /opt/epsos-configuration_tmp/cert/PPT/

ADD ./server.xml /etc/tomcat7

ADD conf/* /opt/epsos-configuration_tmp/cert/PPT/conf/

ADD ./selfcert.sh /opt/epsos-configuration_tmp/cert/PPT/

ADD ./startup.sh /opt/startup.sh


EXPOSE 8080

CMD ["/bin/bash", "/opt/startup.sh"]
