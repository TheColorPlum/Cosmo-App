class ChangeCostToBeStringInFeatures < ActiveRecord::Migration[7.0]
  def change
    change_column :features, :cost, :string
  end
end
