class ChangePriceToBeStringInFeatures < ActiveRecord::Migration[7.0]
  def change
    change_column :features, :price, :string 
  end
end
