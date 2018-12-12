class AddCurrencyToRevenueShare < ActiveRecord::Migration[5.2]
  def change
    add_column :revenue_shares, :currency, :string
  end
end
