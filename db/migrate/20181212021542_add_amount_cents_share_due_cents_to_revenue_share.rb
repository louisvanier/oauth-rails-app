class AddAmountCentsShareDueCentsToRevenueShare < ActiveRecord::Migration[5.2]
  def change
    add_column :revenue_shares, :amount_cents, :integer
    add_column :revenue_shares, :share_due_cents, :integer
  end
end
