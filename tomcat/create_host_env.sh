#!/bin/bash

DL_DIR=/opt/openncp-downloads
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
  echo "^DL_DIR present. Exiting."
  exit
fi

mkdir  $DL_DIR

wget https://openncp.atlassian.net/wiki/download/attachments/65142795/epsos-configuration.zip?api=v2 -O $DL_DIR/epsos-configuration.zip
unzip $DL_DIR/epsos-configuration.zip  -d /opt


mkdir -p /opt/epsos-configuration/cert/PPT/conf

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


rm -fr $DL_DIR
exit

