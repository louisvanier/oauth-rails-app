require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "#from_omniauth returns a user by its email if it exists" do
    user = create(:user, name: 'John Pettruci')
    omniauth_data = { 'email' => 'johnpettruci@example.com' }
    assert_equal user, User.from_omniauth(omniauth_data, true, -> (user) { p user })
  end

  test "#from_omniauth does not execute the new_record_lambda if it does not create a user" do
    name_after_callback = 'not executed'
    user = create(:user, name: 'John Pettruci')
    omniauth_data = { 'email' => 'johnpettruci@example.com' }
    assert_equal user, User.from_omniauth(omniauth_data, true, -> (user) { name_after_callback = user.name })
    assert_equal 'not executed', name_after_callback
  end

  test "#from_omniauth saves a new user if it cant find one by email asd" do
    assert_difference 'User.count' do
        omniauth_data = {
          'email' => 'random@email.com',
          'name' => 'Alexi Laiho',
          'image' => 'https://random.com/images/1'
        }
        omniauth_data.expects(provider: 'oauth_provider')
        omniauth_data.expects(uid: 'imauid')
        User.from_omniauth(
          omniauth_data,
          true,
          -> (user) { p user }
        )
    end
  end

  test "#from_omniauth executes the new_record_lambda only if it creates a user" do
    name_after_callback = ''
    omniauth_data = {
      'email' => 'random@email.com',
      'name' => 'Alexi Laiho',
      'image' => 'https://random.com/images/1'
    }
    omniauth_data.expects(provider: 'oauth_provider')
    omniauth_data.expects(uid: 'imauid')
    User.from_omniauth(
      omniauth_data,
      true,
      -> (user) { name_after_callback = user.name }
    )

    assert_equal 'Alexi Laiho', name_after_callback
  end

  test '#active_for_authentication? returns false if the user is not approved' do
    refute create(:user, approved: false).active_for_authentication?
  end

  test '#active_for_authentication? returns true if the user is approved' do
    assert create(:user, approved: true).active_for_authentication?
  end

  test '#inactive_message is nil if the user is approved' do
    assert_nil create(:user, approved: true).inactive_message
  end

  test '#inactive_message is :not_approved if the user is not approved' do
    assert_equal :not_approved, create(:user, approved: false).inactive_message
  end
end
