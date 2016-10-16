#!/bin/bash

DL_DIR=/opt/openncp-downloads
CACHE_DIR=/opt/openncp-cache
COUNTRY_CODE=fr
PASSWORD=rootroot
ORGANIZATION=sante.gouv.fr
DATABASE=mysql
DATABASE_LOGIN=root

if [ ! -f /usr/bin/java ]
then
  apt-get install -y default-jre
fi

if [ -d /opt/epsos-configuration ]
then
  echo "/opt/epsos-configuration present. Exiting."
  exit
fi

if [ -d $DL_DIR ]
then
  echo "$DL_DIR present. Exiting."
  exit
fi

mkdir  $DL_DIR

if [ -d $CACHE_DIR ]
then
  echo "$CACHE_DIR present. Exiting."
  exit
fi

mkdir  $CACHE_DIR


wget https://openncp.atlassian.net/wiki/download/attachments/65142795/epsos-configuration.zip?api=v2 -O $DL_DIR/epsos-configuration.zip
unzip $DL_DIR/epsos-configuration.zip  -d /opt



mkdir -p /opt/epsos-configuration/cert/PPT/conf


# Properties init

wget https://openncp.atlassian.net/wiki/download/attachments/65142795/OpenNCP-configuration-utility.zip?api=v2 -O $DL_DIR/OpenNCP-configuration-utility.zip
unzip $DL_DIR/OpenNCP-configuration-utility.zip -d /opt/epsos-configuration/


sed -i "s/>username/>$DATABASE_LOGIN/" /opt/epsos-configuration/OpenNCP-configuration-utility/database.config.xml
sed -i "s/>password/>$PASSWORD/" /opt/epsos-configuration/OpenNCP-configuration-utility/database.config.xml
sed -i "s/databasehost/$DATABASE/" /opt/epsos-configuration/OpenNCP-configuration-utility/database.config.xml
sed -i "s/databasename/epsos_properties/" /opt/epsos-configuration/OpenNCP-configuration-utility/database.config.xml

#cacert.sh

wget https://openncp.atlassian.net/wiki/download/attachments/51412998/cacert.sh?api=v2 -O /opt/epsos-configuration/cert/PPT/cacert.sh
cd /opt/epsos-configuration/cert/PPT
sed -i "s/country=\"pt\"/country=\"$COUNTRY_CODE\"/" /opt/epsos-configuration/cert/PPT/cacert.sh
sed -i "s/4096$/-passout pass:$PASSWORD 4096/" /opt/epsos-configuration/cert/PPT/cacert.sh
sed -i "s/openssl req/openssl req -passin pass:$PASSWORD/"  /opt/epsos-configuration/cert/PPT/cacert.sh
sed -i 's/openssl req/openssl req -subj "\/C=$country\/ST=$state\/L=$locality\/O=$organization\/OU=$organizationalunit\/CN=$commonname\/emailAddress=$email"/' /opt/epsos-configuration/cert/PPT/cacert.sh

echo "country=FR
state=Paris
locality=Paris
organization=$ORGANIZATION
organizationalunit=DSSIS
email=thomas.david@sante.gouv.fr
commonname=openncp.sante.gouv.fr
password=$PASSWORD
" >/opt/epsos-configuration/cert/PPT/cacert.sh.tmp
cat /opt/epsos-configuration/cert/PPT/cacert.sh >> /opt/epsos-configuration/cert/PPT/cacert.sh.tmp

mv /opt/epsos-configuration/cert/PPT/cacert.sh.tmp /opt/epsos-configuration/cert/PPT/cacert.sh

sh /opt/epsos-configuration/cert/PPT/cacert.sh

# selfcert.sh

wget https://openncp.atlassian.net/wiki/download/attachments/51412998/selfcert.sh?api=v2  -O /opt/epsos-configuration/cert/PPT/selfcert.sh
wget https://openncp.atlassian.net/wiki/download/attachments/51412998/epSOS_config.zip?api=v2 -O $DL_DIR/epSOS_config.zip
unzip $DL_DIR/epSOS_config.zip -d /opt/epsos-configuration/cert/PPT/

sed -i "s/country=.*/country=\"$COUNTRY_CODE\"/" /opt/epsos-configuration/cert/PPT/selfcert.sh
sed -i "s/passwordKS=.*/passwordKS=\"$PASSWORD\"/" /opt/epsos-configuration/cert/PPT/selfcert.sh
sed -i "s/passwordCA=.*/passwordCA=\"$PASSWORD\"/" /opt/epsos-configuration/cert/PPT/selfcert.sh
sed -i "s/passwordTS=.*/passwordTS=$PASSWORD/" /opt/epsos-configuration/cert/PPT/selfcert.sh

sed -i "s/^CAcertAlias=ppt/CAcertAlias=fr/" /opt/epsos-configuration/cert/PPT/selfcert.sh
sed -i "s/^NcpSignatureAlias=ppt/NcpSignatureAlias=fr/" /opt/epsos-configuration/cert/PPT/selfcert.sh
sed -i "s/^VPNServerSignatureAlias=ppt/VPNServerSignatureAlias=fr/" /opt/epsos-configuration/cert/PPT/selfcert.sh
sed -i "s/^VPNClientSignatureAlias=ppt/VPNClientSignatureAlias=fr/" /opt/epsos-configuration/cert/PPT/selfcert.sh
sed -i "s/^ServiceConsumerSignatureAlias=ppt/ServiceConsumerSignatureAlias=fr/" /opt/epsos-configuration/cert/PPT/selfcert.sh
sed -i "s/^ServiceProviderSignatureAlias=ppt/ServiceProviderSignatureAlias=fr/" /opt/epsos-configuration/cert/PPT/selfcert.sh
sed -i "s/^OCSPSignatureAlias=ppt/OCSPSignatureAlias=fr/" /opt/epsos-configuration/cert/PPT/selfcert.sh

(cd /opt/epsos-configuration/cert/PPT/ && sh /opt/epsos-configuration/cert/PPT/selfcert.sh)

# Configuration hibernate

sed -i "s/mysql:\/\/databasehost/mysql:\/\/$DATABASE/" /opt/epsos-configuration/configmanager.hibernate.xml
sed -i "s/>username/>$DATABASE_LOGIN/" /opt/epsos-configuration/configmanager.hibernate.xml
sed -i "s/>password/>$PASSWORD/" /opt/epsos-configuration/configmanager.hibernate.xml

echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE hibernate-configuration PUBLIC "-//Hibernate/Hibernate Configuration DTD 3.0//EN" "http://hibernate.sourceforge.net/hibernate-configuration-3.0.dtd">
<hibernate-configuration>
    <session-factory>
        <property name="hibernate.dialect">org.hibernate.dialect.MySQLDialect</property>
        <property name="hibernate.connection.driver_class">com.mysql.jdbc.Driver</property>
        <property name="hibernate.connection.url">jdbc:mysql://mysql:3306/epsos_properties?zeroDateTimeBehavior=convertToNull</property>
        <property name="hibernate.connection.username">root</property>
        <property name="hibernate.connection.password">mypassword</property>
        <!-- JDBC connection pool (use the built-in) -->
        <property name="connection.pool_size">1</property>
        <property name="current_session_context_class">thread</property>
        <!-- Disable the second-level cache -->
        <property name="cache.provider_class">org.hibernate.cache.NoCacheProvider</property>
        <!-- Echo all executed SQL to stdout -->
        <property name="show_sql">yes</property>
        <property name="hibernate.hbm2ddl.auto">update</property>
        <mapping class="eu.epsos.configmanager.database.model.Property"/>
    </session-factory>
</hibernate-configuration>
' >  /opt/epsos-configuration/database.config.xml



# TRC-STS
wget https://joinup.ec.europa.eu/nexus/content/repositories/releases/eu/europa/ec/joinup/ecc/epsos-trc-sts/2.3.2/epsos-trc-sts-2.3.2.war -O $CACHE_DIR/TRC-STS.war

rm -fr $DL_DIR
exit

