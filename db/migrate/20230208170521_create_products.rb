class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.text :url

      t.timestamps
    end
  end
end
