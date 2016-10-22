# coding: utf-8
require_relative 'application'
require 'diffy'
require 'differ'

Differ.format = :color
Diffy::Diff.default_format = :color

ActiveRecord::Base.logger.level = Logger::INFO

def print_series_of_line_diffs(revisions)
  revisions.each_cons(2) do |left, right|
    puts Diffy::Diff.new(left, right)
  end
end

def print_series_of_word_diffs(revisions)
  revisions.each_cons(2) do |left, right|
    puts Differ.diff_by_word(right, left)
  end
end

News.edited.find_each do |news|
  if news.title_edited?
    puts '-' * 80
    puts "Новость #{news.id} из агенства #{news.agency.capitalize}"

    print_series_of_word_diffs(news.snapshots.map(&:title).uniq)
  end
end
