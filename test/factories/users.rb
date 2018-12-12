FactoryBot.define do
  factory :user do
    name { "Hill Billy" }
    email { "#{name.gsub(' ', '')}@example.com"}
    share_percentage { 20 }
    approved { true }
    image_url { 'https://example.com/images/1' }
    password { 'imasuperrandomstrongpassword' }
  end
end
