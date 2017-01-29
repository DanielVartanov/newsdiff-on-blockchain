module Agencies
  class Khabar < Agency
    FEED_URL = 'http://khabar.kz/ru/news?format=feed&type=rss'

    def news
      fetch_items.map do |item|
        guid = item.xpath('guid').text
        title = item.xpath('title').text
        link = item.xpath('link').text
        published_at = DateTime.parse(item.xpath('pubDate').text)
        author = item.xpath('author').text
        content = item.xpath('description').text

        NewsData.new 'khabar', guid, title, link, published_at, author, content
      end
    end

    private

    def fetch_items
      raw_xml = HTTP.get(FEED_URL).to_s.force_encoding('utf-8')
      items = Nokogiri::XML(raw_xml).xpath('//rss/channel/item')
    end
  end
end
