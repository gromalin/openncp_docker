#!/bin/bash

service mysql start

echo "show databases"|mysql -u root -p'f866945aa3ea9dc'|grep epsos_properties
if [ $? == 0 ]
then
  echo "epsos_proerties database is present"
else
  echo "creating espsos_properties database" 
  mysqladmin create epsos_properties -u root -p'f866945aa3ea9dc'
fi

if [ ! -d /opt/epsos-configuration/cert/PPT/ROOT ]
then
  sh /opt/epsos-configuration/cert/PPT/cacert.sh
fi

if [ ! -f /opt/epsos-configuration/cert/PPT/keystore/fr-service-provider-keystore.jks ]
then
  sh /opt/epsos-configuration/cert/PPT/selfcert.sh
fi

/bin/bash

