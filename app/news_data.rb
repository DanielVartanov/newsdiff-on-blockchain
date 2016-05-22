class NewsData < Struct.new(:agency, :remote_id, :title, :url, :published_at, :author, :content)
  def checksum
    @checksum ||= Digest::SHA256.hexdigest [remote_id, title, url, published_at, author, content].join(' ')
  end
end
