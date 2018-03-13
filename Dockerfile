FROM ruby:latest
RUN apt-get update -qq && apt-get install -y build-essential curl
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get update && apt-get install -y nodejs
RUN mkdir /dockerails
WORKDIR /dockerails
COPY Gemfile /dockerails/Gemfile
COPY Gemfile.lock /dockerails/Gemfile.lock
RUN bundle install
COPY . /dockerails

ENV RAILS_ENV production
ENV NODE_ENV production
ENV RAKE_ENV=production

RUN npm i -g yarn
RUN yarn install

RUN bundle exec rails assets:precompile --trace
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]