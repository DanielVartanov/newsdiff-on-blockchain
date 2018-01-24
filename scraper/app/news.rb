class News < ActiveRecord::Base
  has_many :snapshots, -> { order(:updated_at) }, dependent: :destroy

  scope :edited, -> { joins(:snapshots, :select => "news_id").group('snapshots.news_id, news.id').having('count(*) > 1') }

  def title_edited?
    snapshots.map(&:title).uniq.size > 1
  end
end
