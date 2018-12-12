class RemoveAmountShareDueFromRevenueShares < ActiveRecord::Migration[5.2]
  def change
    remove_column :revenue_shares, :amount
    remove_column :revenue_shares, :share_due
  end
end
