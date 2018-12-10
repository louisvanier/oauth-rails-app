require 'test_helper'

class RevenueShareTest < ActiveSupport::TestCase
  test '#can_update? returns true if the share was created less than 5 minutes ago' do
    user = create(:revenue_share, created_at: Time.now.utc - 2.minutes)
    assert user.can_update?
  end

  test '#can_update? returns false if the share was created more than 5 minutes ago' do
    refute create(:revenue_share, created_at: Time.now - 10.minutes).can_update?
  end
end
