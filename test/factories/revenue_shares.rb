FactoryBot.define do
  factory :revenue_share do
    amount { 200 }
    share_due { 80 }
    user { nil }
    created_at { Time.now }
  end
end
