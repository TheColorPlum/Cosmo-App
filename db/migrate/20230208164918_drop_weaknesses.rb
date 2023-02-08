class DropWeaknesses < ActiveRecord::Migration[7.0]
  def change
    drop_table :weaknesses
  end
end
