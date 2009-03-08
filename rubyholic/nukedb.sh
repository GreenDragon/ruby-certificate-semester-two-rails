#!/bin/bash
DBS="rubyholics_development rubyholics_test"

for DB in ${DBS}; do
  echo "Working on ${DB}"
  mysql -u root -e "drop database ${DB}"
  mysql -u root -e "create database ${DB}"

  MODE=`echo ${DB} | sed -e 's/rubyholics\_//g'`
  echo "Working on ${MODE}"
  if [ "${MODE}" == "development" ]; then
    rake db:migrate
    rake db:fixtures:load
  else
    rake db:migrate RAILS_ENV=${MODE}
    rake db:fixtures:load RAILS_ENV=${MODE}
  fi
done
