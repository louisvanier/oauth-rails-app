FactoryBot.define do
  factory :tenant do
    subdomain { 'metal-guitarists' }
    admins { ['admin@tehg4m3.com', 'stevevai@tehg4m3.com'] }    
  end
end
