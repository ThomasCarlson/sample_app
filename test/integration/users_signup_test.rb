require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end


  test "invalid signup information" do
    before_count = User.count
    get signup_path
    post users_path, user: { name:  "",
                             email: "user@invalid",
                             password:              "foo",
                             password_confirmation: "bar" }
    after_count = User.count    
    assert_equal before_count, after_count
    assert_select 'div#error_explanation'
    assert_select 'div.alert'

  end

  test "valid signup information with account activation" do
    before_count = User.count
    get signup_path
    post users_path, user: { name:  "Misty",
                             email: "misty@meow.com", 
                             password:              "foobar",
                             password_confirmation: "foobar" }
    after_count = User.count
    assert_equal after_count, before_count + 1
# #TODO Listing 10.22: RESTORE    assert_template 'users/show'
# #TODO Listing 10.22: RESTORE   assert is_logged_in?
    #     assert_not flash.alert

    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    
  end

end


