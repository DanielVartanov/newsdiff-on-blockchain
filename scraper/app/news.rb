class News < ActiveRecord::Base
  has_many :snapshots, -> { select(:id, :news_id, :checksum, :url, :title, :author, :published_at, :created_at, :updated_at).order(:updated_at) }, dependent: :destroy
  scope :edited, -> { joins(:snapshots).select("news.*, snapshots.news_id").group('snapshots.news_id, news.id').having('count(*) > 1') }

  def title_edited?
    snapshots.map(&:title).uniq.size > 1
  end
end
