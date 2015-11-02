# http://www.slideshare.net/cyberblackvoom?utm_campaign=profiletracking&utm_medium=sssite&utm_source=ssslideview
From centos
MAINTAINER itagakishintaro on github

# prepare
RUN yum -y install git gcc make openssl-devel readline-devel zlib-devel
# https://github.com/sstephenson/ruby-build/wiki#suggested-build-environment
RUN yum install -y gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel

# [rbenv](https://gist.github.com/deepak/5925003)

# install rbenv
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
RUN rbenv install 2.2.0
RUN rbenv global 2.2.0
RUN ruby -v
RUN rbenv rehash

# [postgresql](https://github.com/CentOS/CentOS-Dockerfiles/tree/master/postgres/centos7)

RUN yum -y update; yum clean all
RUN yum -y install sudo epel-release; yum clean all
RUN yum -y install postgresql-server postgresql postgresql-contrib supervisor; yum clean all

ADD ./postgresql-setup /usr/bin/postgresql-setup
ADD ./supervisord.conf /etc/supervisord.conf
ADD ./start_postgres.sh /start_postgres.sh

#Sudo requires a tty. fix that.
RUN sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers
RUN chmod +x /usr/bin/postgresql-setup
RUN chmod +x /start_postgres.sh

RUN /usr/bin/postgresql-setup initdb

ADD ./postgresql.conf /var/lib/pgsql/data/postgresql.conf

RUN chown -v postgres.postgres /var/lib/pgsql/data/postgresql.conf

RUN echo "host    all             all             0.0.0.0/0               md5" >> /var/lib/pgsql/data/pg_hba.conf

VOLUME ["/var/lib/pgsql"]

EXPOSE 5432

CMD ["/bin/bash", "/start_postgres.sh"]

# install apache

RUN yum install httpd
RUN systemctl start httpd
RUN systemctl enable httpd

# passengerのインストール

RUN gem install passenger --no-ri --no-rdoc -V
RUN yum -y install libcurl-devel httpd-devel
RUN exit
RUN passenger-install-apache2-module
RUN cp -p /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.org
RUN sed -e "s/AddDefaultCharset UTF-8/# AddDefaultCharset UTF-8/g" /etc/httpd/conf/httpd.conf
RUN echo 'LoadModule passenger_module /home/pr-admin/.rbenv/versions/2.2.0/lib/ruby/gems/2.2.0/gems/passenger-5.0.15/buildout/apache2/mod_passenger.so' >> /etc/httpd/conf/httpd.conf
RUN echo '<IfModule mod_passenger.c>' >> /etc/httpd/conf/httpd.conf
RUN echo '  PassengerRoot /home/pr-admin/.rbenv/versions/2.2.0/lib/ruby/gems/2.2.0/gems/passenger-5.0.15' >> /etc/httpd/conf/httpd.conf
RUN echo '  PassengerDefaultRuby /home/pr-admin/.rbenv/versions/2.2.0/bin/ruby' >> /etc/httpd/conf/httpd.conf
RUN echo '</IfModule>' >> /etc/httpd/conf/httpd.conf
RUN echo 'RailsEnv development' >> /etc/httpd/conf/httpd.conf

# create user for Progress Report
RUN useradd pr-admin
RUN passwd -f -u pr123

# install Progress Report
USER pr-admin
RUN cd /home/pr-admin
RUN git clone https://github.com/itagakishintaro/ProgressReport.git
