# openncp_docker
Dockerfile to build a runnning openncp instance

Tested  Docker "One-click apps" Digital Ocean droplet (Docker 1.12.1 on 16.04)


# How it works

  * MySQL : the official Docker image is used.
  * Tomcat : a bash script is used to download and create the environnement.

# Setup

## Creating a mysql container


* Run the MySQL container

`docker run --rm  --name mysql --env="MYSQL_ROOT_PASSWORD=rootroot" --env="MYSQL_DATABASE=epsos_properties" mysql:latest`

* Create the openncp:tomcat image

`docker build -t openncp:tomcat .`

* Create the Tomcat environment

`cd tomcat`

`./create_host_env.sh`

* Populate the database epsos_properties

`docker run -it --rm -p 8080:8080 -v /opt/epsos-configuration:/opt/epsos-configuration -v $PWD/server.xml:/usr/local/tomcat/conf/server.xml --link mysql -v $PWD/context.xml:/usr/local/tomcat/conf/context.xml -w /opt/epsos-configuration/OpenNCP-configuration-utility/  openncp:tomcat java -jar /opt/epsos-configuration/ncp-configuration-util-1.0.2.jar`

* Run of the tomcat container wirh the TRC-STR war file

`docker run -it --rm -p 8080:8080 -v /opt/epsos-configuration:/opt/epsos-configuration -v $PWD/server.xml:/usr/local/tomcat/conf/server.xml --link mysql -v $PWD/context.xml:/usr/local/tomcat/conf/context.xml -w /opt/epsos-configuration/OpenNCP-configuration-utility/  -v /opt/openncp-cache/TRC-STS.war:/usr/local/tomcat/webapps/TRC-STS.war openncp:tomcat`

* Test that everything went well

`http://<hostname>:<port>/TRC-STS/STSServiceService` 
