# require "test_helper"

# class UsersLoinTest < ActionDispatch::IntegrationTest
#  test "login with invalid information" do
#    get login_path
#    assert_template 'sessions/new'
#    post login_path, params: {session: {email: "", password: ""}}
#    assert_response :unprocessable_entity
#    assert_template 'sessions/new'
#    assert_not flash.empty?
#    get root_path
#    assert flash.empty?
#  end

#   def setup
#     @user = users(:michael)
#   end

#   test "login with valid information" do
#     post login_path, params: { session: { email:    @user.email,
#                                           password: 'password' } }
#     assert_redirected_to @user
#     follow_redirect!
#     assert_template 'users/show'
#     assert_select "a[href=?]", login_path, count: 0
#     assert_select "a[href=?]", logout_path
#     assert_select "a[href=?]", user_path(@user)
#   end
# end



# require "test_helper"

# class UsersLoginTest < ActionDispatch::IntegrationTest

#   def setup
#     @user = users(:michael)
#   end

#   test "login with valid email/invalid password" do
#     get login_path
#     assert_template 'sessions/new'
#     post login_path, params: { session: { email:    @user.email,
#                                           password: "invalid" } }
#     assert_not is_logged_in?
#     assert_response :unprocessable_entity
#     assert_template 'sessions/new'
#     assert_not flash.empty?
#     get root_path
#     assert flash.empty?
#   end

#   test "login with valid information followed by logout" do
#     post login_path, params: { session: { email:    @user.email,
#                                           password: 'password' } }
#     assert is_logged_in?
#     assert_redirected_to @user
#     follow_redirect!
#     assert_template 'users/show'
#     assert_select "a[href=?]", login_path, count: 0
#     assert_select "a[href=?]", logout_path
#     assert_select "a[href=?]", user_path(@user)
#     delete logout_path
#     assert_not is_logged_in?
#     assert_response :see_other
#     assert_redirected_to root_url
#     follow_redirect!
#     assert_select "a[href=?]", login_path
#     assert_select "a[href=?]", logout_path,      count: 0
#     assert_select "a[href=?]", user_path(@user), count: 0
#   end
# end




require "test_helper"

class UsersLogin < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
end

class InvalidPasswordTest < UsersLogin

  test "login path" do
    get login_path
    assert_template 'sessions/new'
  end

  test "login with valid email/invalid password" do
    post login_path, params: { session: { email:    @user.email,
                                          password: "invalid" } }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end

class ValidLogin < UsersLogin

  def setup
    super
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
  end
end

class ValidLoginTest < ValidLogin

  test "valid login" do
    assert is_logged_in?
    assert_redirected_to @user
  end

  test "redirect after login" do
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end

class Logout < ValidLogin

  def setup
    super
    delete logout_path
  end
end

class LogoutTest < Logout

  test "successful logout" do
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_url
  end

  test "redirect after logout" do
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
