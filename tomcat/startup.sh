#!/bin/bash
MYSQL_PASS=mypassword

echo "show databases"|mysql -h mysql -u root -p$MYSQL_PASS|grep epsos_properties > /dev/null
if [ "$?" -eq "0" ]
then
  echo "epsos_proerties database is already present"
else
  echo "creating espsos_properties database"
  echo CREATE DATABASE epsos_properties|mysql -h mysql -u root -p$MYSQL_PASS
fi

if [ ! -d /opt/epsos-configuration/ ]
then
  echo "Initialization of /opt/epsos-configuration"
  mv /opt/epsos-configuration_tmp /opt/epsos-configuration
else
  echo "/opt/epsos-configuration already present"
  rm -fr /opt/epsos-configuration_tmp
fi

cd /opt/epsos-configuration/cert/PPT

if [ ! -d /opt/epsos-configuration/cert/PPT/ROOT ]
then
  echo "CA not present - creation of the CA"
  sh /opt/epsos-configuration/cert/PPT/cacert.sh > /dev/null 2>/dev/null
else
  echo "CA already present"
fi


if [ ! -f /opt/epsos-configuration/cert/PPT/keystore/fr-service-provider-keystore.jks ]
then
  echo "keystore not present - creating and filling it"
  sh /opt/epsos-configuration/cert/PPT/selfcert.sh > /tmp/log 2>&1
else
  echo "keystore already prsent"
fi


/bin/bash

