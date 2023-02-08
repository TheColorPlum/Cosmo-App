class CreateStrengths < ActiveRecord::Migration[7.0]
  def change
    create_table :strengths do |t|
      t.references :feature, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :category

      t.timestamps
    end
  end
end
