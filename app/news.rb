class News < ActiveRecord::Base
  has_many :snapshots
end
