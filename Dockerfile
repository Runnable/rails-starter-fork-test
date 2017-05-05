FROM ruby:2.3.1
RUN rm /bin/sh && ln -s /bin/bash /bin/sh && \
  sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile
RUN apt-get update && apt-get install -y curl libmysqlclient-dev libsasl2-dev build-essential apt-transport-https qt5-default libqt5webkit5-dev dbus xvfb libssl-dev libjemalloc-dev
RUN mkdir /app
WORKDIR /app
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 6.3.0
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash \
  && source $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH   $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
# Gems
ADD Gemfile Gemfile.lock /app/
RUN bundle install --no-deployment || bundle check
ADD config.ru Rakefile /app/
ADD vendor/assets vendor/assets
ADD bin bin
ADD config config
ADD db db
ADD public public
ADD lib lib
ADD app app
# assets
RUN RAILS_ENV=production bundle exec rake assets:precompile
ENV GEM_HOME /bundle
ADD assure_test_dependencies.sh /app/minipod/assure_test_dependencies.sh
EXPOSE 3000
ENV RAILS_SERVE_STATIC_FILES=1
CMD bundle exec rails server --binding=0.0.0.0
