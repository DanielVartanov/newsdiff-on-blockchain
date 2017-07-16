FROM ruby:latest
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN bundle install
CMD ["./scripts/parse_and_save_diffs_in_html.rb"]
