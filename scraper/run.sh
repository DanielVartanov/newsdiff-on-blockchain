#!/bin/bash
bundle exec rake db:migrate
./parse_and_save_diffs_in_html.rb
