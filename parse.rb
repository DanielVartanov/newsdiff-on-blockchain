require_relative 'application'

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
