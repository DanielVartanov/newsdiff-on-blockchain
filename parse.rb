require 'digest'
require 'http'
require 'nokogiri'
require 'active_record'

ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Base.establish_connection YAML::load(File.open('db/config.yml'))['development']

class News < ActiveRecord::Base
  has_many :snapshots
end

class Snapshot < ActiveRecord::Base
  belongs_to :news
end

class NewsData < Struct.new(:remote_id, :title, :url, :published_at, :author, :content)
  def checksum
    @checksum ||= Digest::SHA256.hexdigest [remote_id, title, url, published_at, author, content].join(' ')
  end
end

module Agencies
  class Agency
    def news
      raise 'To be implemented in derivatives'
    end
  end

  class Knews < Agency
    FEED_URL = 'http://knews.kg/feed/'

    def news
      fetch_items.map do |item|
        def item.node_text(node_name)
          xpath(node_name).text
        end

        guid = item.node_text('guid')
        title = item.node_text('title')
        link = item.node_text('link')
        published_at = DateTime.parse(item.node_text('pubDate'))
        author = item.node_text('dc:creator')
        content = item.node_text('content:encoded')

        NewsData.new guid, title, link, published_at, author, content
      end
    end

    private

    def fetch_items
      raw_xml = HTTP.get(FEED_URL).to_s.force_encoding('utf-8')
      items = Nokogiri::XML(raw_xml).xpath('//rss/channel/item')
    end
  end
end

Agencies::Knews.new.tap do |agency|
  agency.news.each do |news_data|
    news = News.find_or_create_by! remote_id: news_data.remote_id

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
