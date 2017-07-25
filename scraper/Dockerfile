FROM ruby:latest
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN bundle install
RUN bundle exec rake db:migrate
CMD ["./scripts/parse_and_save_diffs_in_html.rb"]
