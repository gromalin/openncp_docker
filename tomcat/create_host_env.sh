#!/bin/bash

DL_DIR=/opt/openncp-downloads
COUNTRY_CODE=fr
PASSWORD=rootroot

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
wget https://openncp.atlassian.net/wiki/download/attachments/51412998/cacert.sh?api=v2 -O /opt/epsos-configuration/cert/PPT/cacert.sh
cd /opt/epsos-configuration/cert/PPT
sed -i "s/country=\"pt\"/country=\"$COUNTRY_CODE\"/" /opt/epsos-configuration/cert/PPT/cacert.sh
sed -i "s/4096$/-passout pass:$PASSWORD 4096/" /opt/epsos-configuration/cert/PPT/cacert.sh
sed -i "s/openssl req/openssl req -passin pass:$PASSWORD/"  /opt/epsos-configuration/cert/PPT/cacert.sh
sed -i 's/openssl req/openssl req -subj "\/C=$country\/ST=$state\/L=$locality\/O=$organization\/OU=$organizationalunit\/CN=$commonname\/emailAddress=$email"/' /opt/epsos-configuration/cert/PPT/cacert.sh



echo "country=FR
state=Paris
locality=Paris
organization="Ministere de la Sante"
organizationalunit=DSSIS
email=thomas.david@sante.gouv.fr
commonname=openncp.sante.gouv.fr
password=$PASSWORD
" >/opt/epsos-configuration/cert/PPT/cacert.sh.tmp
cat /opt/epsos-configuration/cert/PPT/cacert.sh >> /opt/epsos-configuration/cert/PPT/cacert.sh.tmp

mv /opt/epsos-configuration/cert/PPT/cacert.sh.tmp /opt/epsos-configuration/cert/PPT/cacert.sh

echo $PWD
sh /opt/epsos-configuration/cert/PPT/cacert.sh 

rm -fr $DL_DIR
exit

if [ ! -f /opt/epsos-configuration/cert/PPT/keystore/fr-service-provider-keystore.jks ]
then
  echo "keystore not present - creating and filling it"
  sh /opt/epsos-configuration/cert/PPT/selfcert.sh > /tmp/log 2>&1
else
  echo "keystore already prsent"
fi


/bin/bash

