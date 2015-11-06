#!/bin/bash

cd /home/pr/ProgressReport
# http://ayumu-homes.hateblo.jp/entry/2015/02/08/174838
gem install nokogiri -- --use-system-libraries=true --with-xml2-include=/usr/include/libxml2/
bundle install --without test development
bundle update
bundle exec rake db:migrate RAILS_ENV=docker
