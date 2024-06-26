class CreateSubEras < ActiveRecord::Migration[7.0]
  def change
    create_table :sub_eras do |t|
      t.string :arabic_name
      t.string :english_name
      t.text :arabic_info
      t.integer :points, default: 0
      t.text :english_info
      t.references :era, null: false, foreign_key: true
      t.integer :tier, default: 0
      t.integer :point, default: 0.0

      t.timestamps
    end
  end
end
