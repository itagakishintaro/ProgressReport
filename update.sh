#! /bin/bash

cd /home/pr

# backup
cp -rf ProgressReport ProgressReport`date +%Y%m%d_%H%M%S`
cd /home/pr/ProgressReport

# git
git pull origin master

# bundle
rails console -e docker
bundle install
bundle update
bundle exec rake db:migrate RAILS_ENV=docker

# httpd
service httpd restart
