#!/bin/bash

cd /home/pr/ProgressReport
rails console -e docker
bundle install
bundle update
bundle exec rake db:migrate RAILS_ENV=docker
