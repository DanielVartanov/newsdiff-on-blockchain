#!/usr/bin/env ruby

require_relative './scraper'
require 'differ'
require 'erb'

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
    begin
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
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
    end
    GC.start
  end

  edited_news_html = ''
  edited_news = News.edited.order(created_at: :desc)
  edited_news.each do |news|
    if news.title_edited?
      edited_news_html += '<div class="news--item">'
      edited_news_html += "<p>Новость #{news.id} из агенства #{news.agency.capitalize} от <span> [#{formatted_datetime(news.created_at)}]</span> "
      edited_news_html += "<a href='#{news.snapshots.first.url}'>#{news.snapshots.first.url}</a></p>"
      edited_news_html += print_series_of_word_diffs(news.snapshots)
      edited_news_html += '</div>'
      # TODO: change code above, use erb features and pass the object
    end
  end
  edited_news = nil
  GC.start

  renderer = ERB.new(File.read('templates/index.html.erb', encoding: 'utf-8'))

  File.open('data/index.html', 'w') do |f|
    f.write(renderer.result(binding))
  end

  sleep 60

end
