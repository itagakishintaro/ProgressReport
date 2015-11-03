#!/bin/bash

cd /home/pr/ProgressReport
bundle install
bundle update
bundle exec rake db:migrate
