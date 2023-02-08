class CreateContents < ActiveRecord::Migration[7.0]
  def change
    create_table :contents do |t|
      t.references :team, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.text :url
      t.boolean :active

      t.timestamps
    end
  end
end
