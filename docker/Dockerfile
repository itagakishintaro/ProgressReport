# http://www.slideshare.net/cyberblackvoom?utm_campaign=profiletracking&utm_medium=sssite&utm_source=ssslideview

From centos:centos6
MAINTAINER itagakishintaro on github

# create user

RUN yum -y install passwd
RUN useradd pr
RUN passwd -f -u pr

# postgres

RUN rpm -i http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-redhat93-9.3-3.noarch.rpm
RUN yum -y install postgresql93-server  postgresql93-devel postgresql93-docs postgresql93-libs; yum clean all

RUN chkconfig postgresql-9.3 on
RUN service postgresql-9.3 initdb
RUN echo "host    all             all             0.0.0.0/0               md5" >> /var/lib/pgsql/9.3/data/pg_hba.conf
RUN sed -i -e "s/#bytea_output = 'hex'/bytea_output = 'escape'/g" /var/lib/pgsql/9.3/data/postgresql.conf
RUN service postgresql-9.3 start
ADD createdb.sh /createdb.sh
RUN chmod +x /createdb.sh
RUN /createdb.sh
RUN sed -i -e "s/local   all             all                                     peer/local   all             all                                     md5/g" /var/lib/pgsql/9.3/data/pg_hba.conf
RUN service postgresql-9.3 start

EXPOSE 5432

# httpd

RUN yum -y update && yum clean all
RUN yum -y install httpd && yum clean all

RUN chkconfig httpd on
RUN service httpd start

EXPOSE 80

# [ruby](https://gist.github.com/deepak/5925003)

# install rbenv

RUN yum -y install git make tar
# https://github.com/sstephenson/ruby-build/wiki#suggested-build-environment
RUN yum -y install gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel

RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN echo '# rbenv setup' > /etc/profile.d/rbenv.sh
RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
RUN echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN chmod +x /etc/profile.d/rbenv.sh

# install ruby-build

RUN mkdir /usr/local/rbenv/plugins
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
ENV RBENV_ROOT /usr/local/rbenv
ENV PATH "$RBENV_ROOT/bin:$RBENV_ROOT/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# does not work. PATH is set to
# $RBENV_ROOT/shims:$RBENV_ROOT/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# install ruby

RUN rbenv --version
RUN rbenv install 2.3.8
RUN rbenv global 2.3.8
RUN ruby -v
RUN rbenv rehash

# passenger

RUN gem install passenger --no-ri --no-rdoc -V
RUN yum -y install libcurl-devel httpd-devel gcc-c++
RUN exit
RUN passenger-install-apache2-module

# set httpd.conf

RUN sed -i -e 's/DocumentRoot "\/var\/www\/html"/DocumentRoot "\/home\/pr\/ProgressReport\/public"/g' /etc/httpd/conf/httpd.conf
RUN echo '<Directory "/home/pr/ProgressReport/public">' >> /etc/httpd/conf/httpd.conf
RUN echo 'Options -Indexes FollowSymLinks' >> /etc/httpd/conf/httpd.conf
RUN echo 'AllowOverride All' >> /etc/httpd/conf/httpd.conf
RUN echo '</Directory>' >> /etc/httpd/conf/httpd.conf

RUN cp -p /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.org
RUN sed -i -e "s/AddDefaultCharset UTF-8/# AddDefaultCharset UTF-8/g" /etc/httpd/conf/httpd.conf
RUN echo 'LoadModule passenger_module /usr/local/rbenv/versions/2.3.8/lib/ruby/gems/2.3.8/gems/passenger-5.0.21/buildout/apache2/mod_passenger.so' >> /etc/httpd/conf/httpd.conf
RUN echo '<IfModule mod_passenger.c>' >> /etc/httpd/conf/httpd.conf
RUN echo '  PassengerRoot /usr/local/rbenv/versions/2.3.8/lib/ruby/gems/2.3.8/gems/passenger-5.0.21' >> /etc/httpd/conf/httpd.conf
RUN echo '  PassengerDefaultRuby /usr/local/rbenv/shims/ruby' >> /etc/httpd/conf/httpd.conf
RUN echo '</IfModule>' >> /etc/httpd/conf/httpd.conf
RUN echo 'RailsEnv pr' >> /etc/httpd/conf/httpd.conf

# install Progress Report

RUN yum -y install libxml2-devel libxslt-devel libpq-dev postgresql-devel sqlite-devel
RUN git clone https://github.com/itagakishintaro/ProgressReport.git /home/pr/ProgressReport
RUN sed -i -e "s/# gem 'therubyracer'/gem 'therubyracer'/g" /home/pr/ProgressReport/Gemfile
RUN chown -R pr /home/pr/ProgressReport
RUN chmod +x /home/pr
RUN gem install bundler

# bundle config build.pg --with-pg-config=/usr/pgsql-9.3/bin/pg_config
ADD ./run-pr.sh /home/pr/run-pr.sh
RUN chmod -v +x /home/pr/run-pr.sh
RUN chown pr /home/pr/run-pr.sh
RUN sed -i -e "s/# config.secret_key = 'b3b6eee7381b583dc16ae58e230767124d0ee73a962d85cffc3a4357a1b0bdd977bedbc1411d7f52a32ec6ee4de23b0d75202b03d155461cdc72cc965cba2de6'/config.secret_key = 'b3b6eee7381b583dc16ae58e230767124d0ee73a962d85cffc3a4357a1b0bdd977bedbc1411d7f52a32ec6ee4de23b0d75202b03d155461cdc72cc965cba2de6'/g" /home/pr/ProgressReport/config/initializers/devise.rb

#start service script
RUN echo -e "service postgresql-9.3 start\nservice httpd start\n/bin/bash" > /start_service.sh
RUN chmod o+x /start_service.sh

CMD ["/start_service.sh"]
