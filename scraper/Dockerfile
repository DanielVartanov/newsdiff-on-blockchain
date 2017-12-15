FROM ruby:latest
RUN mkdir -p /usr/src/app
COPY Gemfile /usr/src/app/Gemfile
COPY Gemfile.lock /usr/src/app/Gemfile.lock
WORKDIR /usr/src/app
RUN bundle install
COPY . /usr/src/app
#RUN bundle exec rake db:migrate
CMD ["./run.sh"]
