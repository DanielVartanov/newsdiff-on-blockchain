module Agencies
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

        NewsData.new 'knews', guid, title, link, published_at, author, content
      end
    end

    private

    def fetch_items
      raw_xml = HTTP.get(FEED_URL).to_s.force_encoding('utf-8')
      items = Nokogiri::XML(raw_xml).xpath('//rss/channel/item')
    end
  end
end
