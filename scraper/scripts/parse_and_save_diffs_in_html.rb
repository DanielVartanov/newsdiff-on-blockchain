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
  end

  html = '
  <html>
  <head>
      <title>Newsdiff -- Detects edited news, stores proof on blockchain</title>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, user-scalable=0">
      <meta name="format-detection" content="telephone=no">
      <meta name="title" content="Newsdiff">
      <meta name="description" content="Detects edited news, stores proof on blockchain">

      <link href="https://fonts.googleapis.com/css?family=Noto+Sans" rel="stylesheet">

      <style type="text/css">
          * {
              box-sizing: border-box;
              margin: 0;
              padding: 0;
          }
          body {
              width: 100%;
              color: #c5c5c5;
              background: #2e2e2e;
              box-sizing: border-box;
              padding-top: 60px;
              font-size: 14px;
              line-height: 1.4;
              font-family: "Noto Sans", sans-serif;
          }
          del {
              color: #C62828;
          }
          ins {
              color: #8BC34A;
          }
          hr {
              margin-top: 20px;
              opacity: .5;
          }
          p {
              color: #918f90;
              white-space: pre-line;
              word-wrap: break-word;
              margin-top: 0;
          }
          a {
              color: #dddddd;
              transition: all .4s;
          }
          a:hover{
              transition: all .4s;
              color: #80D8FF;
          }
          .logo {
              color: #fff;
              font-size: 32px;
              font-weight: 900;
              text-decoration: none;
          }
          .logo-text{
              color: #ffffff;
              font-size: 16px;
          }
          .news--item {
              padding: 30px 0;
              border-bottom: 1px solid #eee;
          }
          header {
              border-bottom: 1px solid #dddddd;
              width: 100%;
              position: fixed;
              top: 0;
              left: 0;
              background: #272727;
          }
          header section {
              display: flex;
              justify-content: space-between;
              align-items: center;
              max-width: 1160px;
              margin: 10px auto;
          }
          @media screen and (max-width: 1200px){
              header{
                  padding: 0 20px;
              }
          }
          @media screen and (max-width: 768px){
              body{
                  padding-top: 130px;
              }
              header section {
                  flex-direction: column;
                  text-align: center;
              }
              .logo{
                  font-size: 26px;
              }
              .logo-text{
                  margin-top: 15px;
                  margin-bottom: 15px;
              }
          }
          @media screen and (max-width: 545px){
              .git--share img{
                  width: 90px;
              }
          }
          .nav {
              /*display: flex;*/
              display: none;
              justify-content: space-between;
              list-style: none;
              margin: 0;
          }
          .nav li {
              margin: 0 0 0 40px;
          }
          .nav a {
              font-weight: 100;
              text-decoration: none;
              color: #eee;
          }
          .nav a:hover {
              color: #80D8FF;
              transition: all .4s;
          }
          .date{
              color: #fff;
          }
          main {
              max-width: 1200px;
              margin: 30px auto;
              padding: 0 20px;
          }
          .news--item a{
              display: block;
              padding: 20px 0;
              line-height: 1;
          }
      </style>
  </head>
  <body>
  <a class="git--share" href="https://github.com/you"><img style="position: absolute; top: 0; right: 0; border: 0; z-index: 99;" src="https://camo.githubusercontent.com/e7bbb0521b397edbd5fe43e7f760759336b5e05f/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677265656e5f3030373230302e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_green_007200.png"></a>
  <header>
      <section>
          <a class="logo" href="/">NEWSDIFF.KG</a>
          <div class="logo-text">
              Detects edited news, stores proof on blockchain
          </div>
      </section>
  </header>
  <main>
      <h1>Архив новостей</h1>
'

  News.edited.order(created_at: :desc).each do |news|
    if news.title_edited?
      html += '<div class="news--item">'
      html += "<p>Новость #{news.id} из агенства #{news.agency.capitalize} от <span> [#{formatted_datetime(news.created_at)}]</span> "
      html += "<a href='#{news.snapshots.first.url}'>#{news.snapshots.first.url}</a></p>"
      html += print_series_of_word_diffs(news.snapshots)
      html += '</div>'
    end
  end

  html += '</main></body></html>'

  File.open('data/index.html', 'w') do |f|
    f.write(html)
  end

  sleep 60

end
