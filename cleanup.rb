require_relative 'application'

News.where('created_at < ?', 1.week.ago).destroy_all
