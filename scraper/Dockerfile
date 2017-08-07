FROM ruby:latest
RUN mkdir -p /usr/src/app
COPY Gemfile /usr/src/app/Gemfile
COPY Gemfile.lock /usr/src/app/Gemfile.lock
WORKDIR /usr/src/app
RUN bundle install
COPY . /usr/src/app
RUN bundle exec rake db:migrate
CMD ["./scripts/parse_and_save_diffs_in_html.rb"]
