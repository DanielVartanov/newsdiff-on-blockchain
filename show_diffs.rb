# coding: utf-8
require_relative 'application'
require 'diffy'
require 'differ'

Differ.format = :color
Diffy::Diff.default_format = :color

ActiveRecord::Base.logger.level = Logger::INFO

def formatted_datetime(datetime)
  datetime.strftime '%-d/%-m %H:%M'
end

def print_series_of_line_diffs(revisions)
  revisions.each_cons(2) do |left, right|
    puts Diffy::Diff.new(left, right)
  end
end

def print_series_of_word_diffs(revisions)
  revisions.each_cons(2) do |left, right|
    unless left.title == right.title
      puts "[#{formatted_datetime(right.created_at)}] #{Differ.diff_by_word(right.title, left.title)}"
    else
      puts "[#{formatted_datetime(right.created_at)}] Изменены другие данные"
    end
  end
end

News.edited.find_each do |news|
  if news.title_edited?
    puts '-' * 80
    puts "Новость #{news.id} из агенства #{news.agency.capitalize} от [#{formatted_datetime(news.created_at)}] #{news.snapshots.first.url}"

    print_series_of_word_diffs(news.snapshots)
  end
end
