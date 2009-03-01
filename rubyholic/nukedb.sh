#!/bin/bash
DB="rubyholics_development"

mysql -u root -e "drop database ${DB}"
mysql -u root -e "create database ${DB}"

rake db:migrate
rake db:fixtures:load
