class DropFeatures < ActiveRecord::Migration[7.0]
  def change
    drop_table :features
  end
end
