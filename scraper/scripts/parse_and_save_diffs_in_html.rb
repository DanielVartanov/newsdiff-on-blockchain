#!/usr/bin/env ruby

require_relative '../scraper'
require 'differ'

Differ.format = :html

def formatted_datetime(datetime)
  datetime.strftime '%-d/%-m %H:%M'
end

def print_series_of_word_diffs(revisions)
  revisions.each_cons(2) do |left, right|
    unless left.title == right.title
      return "[#{formatted_datetime(right.created_at)}] #{Differ.diff_by_word(right.title, left.title)} <br>"
    end
    return "[#{formatted_datetime(right.created_at)}] Изменены другие данные <br>"
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


loop do
  agencies.each do |agency|
    agency.news.each do |news_data|
      begin
        news = News.find_or_create_by! agency: news_data.agency, remote_id: news_data.remote_id
        unless news.snapshots.exists? checksum: news_data.checksum
          news.snapshots.create! checksum: news_data.checksum,
                                 url: news_data.url,
                                 title: news_data.title,
                                 author: news_data.author,
                                 published_at: news_data.published_at,
                                 content: news_data.content
        end
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end

  html = '
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, user-scalable=0">
  <meta name="format-detection" content="telephone=no">

  <style type="text/css">
    body{
      max-width: 1200px;
      margin: 30px auto;
      width: 100%;
      font-family: Arial, sans-serif;
      background: #231f20;
      color: #918f90;
      padding: 0 20px;
      box-sizing: border-box;
      font-size: 16px;
      line-height: 1.4;
      color: #ccc;
    }
    del{
      color: #ec2227;
    }
    ins{
      color: #13af13;
    }
    hr{
      margin-top: 20px;
      opacity: .2;
    }
    p{
      color: #918f90;
      white-space: pre-line;
        word-wrap: break-word;
    }
  </style>'

  News.edited.order(created_at: :desc).each do |news|
    if news.title_edited?
      html += '<hr>'
      html += "<p>Новость #{news.id} из агенства #{news.agency.capitalize} от [#{formatted_datetime(news.created_at)}] #{news.snapshots.first.url}</p>"
      html += print_series_of_word_diffs(news.snapshots)
    end
  end

  File.open('data/index.html', 'w') do |f|
    f.write(html)
  end

  sleep 60

end
