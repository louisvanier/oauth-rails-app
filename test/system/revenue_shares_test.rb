require "application_system_test_case"

class RevenueSharesTest < ApplicationSystemTestCase
  setup do
    @revenue_share = revenue_shares(:one)
  end

  test "visiting the index" do
    visit revenue_shares_url
    assert_selector "h1", text: "Revenue Shares"
  end

  test "creating a Revenue share" do
    visit revenue_shares_url
    click_on "New Revenue Share"

    fill_in "Amount", with: @revenue_share.amount
    fill_in "Share Due", with: @revenue_share.share_due
    fill_in "User", with: @revenue_share.user_id
    click_on "Create Revenue share"

    assert_text "Revenue share was successfully created"
    click_on "Back"
  end

  test "updating a Revenue share" do
    visit revenue_shares_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @revenue_share.amount
    fill_in "Share Due", with: @revenue_share.share_due
    fill_in "User", with: @revenue_share.user_id
    click_on "Update Revenue share"

    assert_text "Revenue share was successfully updated"
    click_on "Back"
  end

  test "destroying a Revenue share" do
    visit revenue_shares_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Revenue share was successfully destroyed"
  end
end
