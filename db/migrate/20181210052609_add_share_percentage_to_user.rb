class AddSharePercentageToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :share_percentage, :integer, default: 0, nil: false
  end
end
