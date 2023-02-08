class DropContenthubsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :content_hubs
  end
end
