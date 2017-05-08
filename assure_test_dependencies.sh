#!/usr/bin/env bash
db_host=$1
db_host=${db_host:-db}

max_retries=${MAX_RETRIES:-1000}
retries=$max_retries

export RAILS_ENV=development

while [ $retries -gt 0 ] ;  do
    echo "rails db:setup"
    ./bin/bundle exec rails db:setup
    db_readiness=$?
    echo "remaining retries: ${retries}"
    if [ $db_readiness -ne 0 ] ; then
        ((retries--))
        sleep 2
    else
        echo "db successful"
        break
    fi
done

if [ $retries -eq 0 ] ; then
    echo "Database connection failed after ${max_retries}"
    exit 1
else
    set -e
    echo "rake db:seed"
    RAILS_ENV=development ./bin/bundle exec rake db:seed
    echo "rails s -b 0.0.0.0"
    RAILS_ENV=development ./bin/bundle exec rails s -b 0.0.0.0
fi
