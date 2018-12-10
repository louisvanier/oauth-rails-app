require 'test_helper'

class RevenueSharesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  TEST_SUBDOMAIN = 'black-metal'

  setup do
    create_tenant(subdomain: TEST_SUBDOMAIN)
    host! "#{TEST_SUBDOMAIN}.example.com"
  end

  test "#index" do
    create_and_sign_in_user(admin: true, subdomain: TEST_SUBDOMAIN)
    get revenue_shares_url
    assert_response :success
  end

  test "#index Non-admin users are unauthorized" do
    create_and_sign_in_user(admin: false, subdomain: TEST_SUBDOMAIN)

    get revenue_shares_index_url
    assert_response :unauthorized
    assert_empty response.body
  end

  test '#prepare loads the last 5 revenue shares' do
    create_and_sign_in_user(admin: false, subdomain: TEST_SUBDOMAIN)

    get prepare_revenue_shares_url
    assert_response :success
  end

  test '#update returns not_found when the id is not found' do
    create_and_sign_in_user(admin: true, subdomain: TEST_SUBDOMAIN)

    patch revenue_share_url(id: 999)
    assert_response :not_found
  end
end
