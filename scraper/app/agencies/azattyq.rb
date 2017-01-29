module Agencies
  class Azattyq < Agency
    FEED_URL = 'http://rus.azattyq.org/api/'

    def news
      fetch_items.map do |item|
        guid = item.xpath('guid').text
        title = item.xpath('title').text
        link = item.xpath('link').text
        published_at = DateTime.parse(item.xpath('pubDate').text)
        author = ''
        content = item.xpath('description').text

        NewsData.new 'azattyq', guid, title, link, published_at, author, content
      end
    end

    private

    def fetch_items
      raw_xml = HTTP.get(FEED_URL).to_s.force_encoding('utf-8')
      items = Nokogiri::XML(raw_xml).xpath('//rss/channel/item')
    end
  end
end
