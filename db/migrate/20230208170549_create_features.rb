class CreateFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table :features do |t|
      t.references :product, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.text :url
      t.float :cost
      t.float :price

      t.timestamps
    end
  end
end
