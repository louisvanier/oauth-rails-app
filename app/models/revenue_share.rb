class RevenueShare < ApplicationRecord
  belongs_to :user
  validates :amount, numericality: { greater_than: 0 }, presence: true

  def create(amount: ,share_percentage:, notes: nil)
    assign_attributes(
      amount: amount,
      share_due: amount * (share_percentage / 100.0),
      # notes: notes,
    )
    save
  end

  def can_update?
    (((Time.now.utc - created_at.utc) % 3600) / 60) <= 5
  end
end
