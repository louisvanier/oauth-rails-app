require 'test_helper'

class RevenueSharesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get revenue_shares_index_url
    assert_response :success
  end

  test "should get new" do
    get revenue_shares_new_url
    assert_response :success
  end

end
