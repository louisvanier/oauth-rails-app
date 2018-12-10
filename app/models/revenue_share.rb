class RevenueShare < ApplicationRecord
  belongs_to :user
  validates :amount, numericality: { greater_than: 0 }, presence: true

  def create(amount: ,share_percentage:, notes:)
    super(
      amount: amount,
      share_due: amount * share_percentage,
      notes: notes,
    )
  end

  def can_update?
    (((Time.now.utc - created_at.utc) % 3600) / 60) <= 5
  end
end
