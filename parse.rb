require_relative 'application'

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
