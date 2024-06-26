class CreateCharacters < ActiveRecord::Migration[7.0]
  def change
    create_table :characters do |t|
      t.string :arabic_name
      t.string :english_name
      t.date :date_of_birth
      t.date :date_of_death
      t.text :arabic_info
      t.string :thumb_image
      t.string :cover_image
      t.integer :points, default: 0
      t.text :english_info
      t.references :sub_era, null: false, foreign_key: true
      t.integer :tier, default: 0

      t.timestamps
    end
  end
end
