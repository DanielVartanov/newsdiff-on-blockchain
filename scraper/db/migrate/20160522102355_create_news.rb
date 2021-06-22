class CreateNews < ActiveRecord::Migration[6.0]
  def change
    create_table :news do |t|
      t.string :agency
      t.string :remote_id
      t.timestamps null: false
    end
  end
end
