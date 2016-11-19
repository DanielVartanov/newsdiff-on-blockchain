module Agencies
  class Sputnik < Agency
    FEED_URL = 'http://ru.sputnik.kg/export/rss2/archive/index.xml'

    def news
      fetch_items.map do |item|
        guid = item.xpath('guid').text
        title = item.xpath('title').text
        link = item.xpath('link').text
        published_at = DateTime.parse(item.xpath('pubDate').text)
        author = ''
        content = item.xpath('description').text

        NewsData.new 'kloop', guid, title, link, published_at, author, content
      end
    end

    private

    def fetch_items
      raw_xml = HTTP.get(FEED_URL).to_s.force_encoding('utf-8')
      Nokogiri::XML(raw_xml).xpath('//rss/channel/item')
    end
  end
end
