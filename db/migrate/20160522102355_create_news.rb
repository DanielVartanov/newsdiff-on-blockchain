class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :remote_id
      t.timestamps null: false
    end
  end
end
