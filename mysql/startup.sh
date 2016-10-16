#!/bin/bash

service mysql start

echo "show databases"|mysql -u root -p'f866945aa3ea9dc'|grep epsos_properties
if [ $? == 0 ]
then
  echo "epsos_properties database is present"
else
  echo "creating espsos_properties database" 
  mysqladmin create epsos_properties -u root -p'f866945aa3ea9dc'
fi


/bin/bash

