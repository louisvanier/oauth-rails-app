class RevenueShare < ApplicationRecord
  belongs_to :user

  monetize :amount_cents, with_model_currency: :currency
  monetize :share_due_cents, with_model_currency: :currency

  validates :amount_cents, numericality: { greater_than: 0 }, presence: true

  def create(amount: ,share_percentage:, notes: nil)
    assign_attributes(
      amount: amount,
      share_due: amount * (share_percentage / 100.0),
      # notes: notes,
    )
    save
  end

  def can_update?
    ((Time.now.utc - created_at.utc) / 60) <= 5.0
  end
end
