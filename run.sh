#!/bin/bash

. /etc/apache2/envvars 

#Cleanup PID-file
rm ${APACHE_PID_FILE}

apache2 -e debug -DFOREGROUND
