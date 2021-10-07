FROM ruby:2.7.3
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# yarnパッケージ管理ツールをインストール
RUN wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list
RUN set -x && apt-get update -y -qq && apt-get install -yq nodejs yarn

# Node.jsをインストール
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
apt-get install nodejs


RUN mkdir /fd_tube_app
WORKDIR /fd_tube_app
COPY Gemfile /fd_tube_app/Gemfile
COPY Gemfile.lock /fd_tube_app/Gemfile.lock
RUN bundle install
COPY . /fd_tube_app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
# EXPOSE 3000

# Start the main process.
# CMD ["rails", "server", "-b", "0.0.0.0"]

RUN mkdir -p tmp/sockets
RUN mkdir -p tmp/pids
