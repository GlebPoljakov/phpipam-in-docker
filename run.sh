#!/bin/bash

. /etc/apache2/envvars 

apache2 -e debug -DFOREGROUND
