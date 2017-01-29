module Agencies
  class Kabar < Agency
    FEED_URL = 'http://www.kabar.kg/rss'

    def news
      fetch_items.map do |item|
        title = item.xpath('title').text
        link = item.xpath('link').text
        remote_id = link
        published_at = DateTime.parse(item.xpath('pubDate').text)
        author = ''
        content = item.xpath('description').text

        NewsData.new 'kabar', remote_id, title, link, published_at, author, content
      end
    end

    private

    def fetch_items
      raw_xml = HTTP.get(FEED_URL).to_s.force_encoding('utf-8')
      items = Nokogiri::XML(raw_xml).xpath('//rss/channel/item')
    end
  end
end
