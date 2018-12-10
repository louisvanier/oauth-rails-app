class CreateRevenueShares < ActiveRecord::Migration[5.2]
  def change
    create_table :revenue_shares do |t|
      t.money :amount
      t.money :share_due
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
