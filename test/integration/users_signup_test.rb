require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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

  test "valid signup information" do
    before_count = User.count
    get signup_path
    post_via_redirect users_path, user: { name:  "Riley",
                             email: "riley@woof.com", 
                            password:              "foobar",
                             password_confirmation: "foobar" }
    after_count = User.count
    assert_equal after_count, before_count + 1
    assert_template 'users/show'
    assert is_logged_in?
    assert_not flash.alert
  end

end


