#!/usr/bin/env ruby

require_relative '../scraper'
require 'differ'

Differ.format = :html

#ActiveRecord::Base.logger.level = Logger::INFO

def formatted_datetime(datetime)
  datetime.strftime '%-d/%-m %H:%M'
end

def print_series_of_word_diffs(revisions)
  revisions.each_cons(2) do |left, right|
    unless left.title == right.title
      puts "[#{formatted_datetime(right.created_at)}] #{Differ.diff_by_word(right.title, left.title)} <br>"
    else
      puts "[#{formatted_datetime(right.created_at)}] Изменены другие данные <br>"
    end
  end
end

######

agencies = [Agencies::Azattyq.new,
            Agencies::Knews.new,
            Agencies::Azattyk.new,
            Agencies::Kabar.new,
            Agencies::Kg24.new,
            Agencies::Kloop.new,
            Agencies::Kyrtag.new,
            Agencies::Tazabek.new,
            Agencies::Vb.new,
            Agencies::Zanoza.new,
            Agencies::Sputnik.new]

agencies.each do |agency|
  agency.news.each do |news_data|
    news = News.find_or_create_by! agency: news_data.agency, remote_id: news_data.remote_id

    unless news.snapshots.exists? checksum: news_data.checksum
      news.snapshots.create! checksum: news_data.checksum,
                             url: news_data.url,
                             title: news_data.title,
                             author: news_data.author,
                             published_at: news_data.published_at,
                             content: news_data.content
    end
  end
end

News.edited.find_each do |news|
  if news.title_edited?
    puts '-' * 80
    puts "<p>Новость #{news.id} из агенства #{news.agency.capitalize} от [#{formatted_datetime(news.created_at)}] #{news.snapshots.first.url}</p>"

    print_series_of_word_diffs(news.snapshots)
  end
end
