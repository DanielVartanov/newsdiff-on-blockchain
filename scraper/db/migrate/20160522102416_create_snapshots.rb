class CreateSnapshots < ActiveRecord::Migration
  def change
    create_table :snapshots do |t|
      t.references :news
      t.string :checksum
      t.string :url
      t.string :title
      t.string :author
      t.datetime :published_at
      t.text :content
      t.timestamps null: false
    end
  end
end
