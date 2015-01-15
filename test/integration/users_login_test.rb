require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user

  def setup
    @user = User.create(username: 'example', password: 'password')
    visit root_url
  end

  test 'user cannot login with invalid credentials' do
    fill_in 'session[username]', with: ''
    fill_in 'session[password]', with: ''
    click_link_or_button 'Login'
    within('#flash_errors') do
      assert page.has_content?('Invalid credentials')
    end
  end

  test 'user can login with valid credentials' do
   fill_in 'session[username]', with: 'example'
   fill_in 'session[password]', with: 'password'
   click_link_or_button 'Login'

   assert_equal user_path(user), current_path
   within('#flash_messages') do
     assert page.has_content?('You have successfully logged in')
   end
  end

  test 'a logged in user can see their ideas' do
    user.ideas.create(name: 'Eating Ice Cream')
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit user_path(user)
    within('#ideas') do
      assert page.has_content?('Your Ideas:')
      assert page.has_content?('Eating Ice Cream')
    end
  end

  test 'a user can log out' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit user_path(user)
    click_link_or_button('Logout')
    within('#flash_messages') do
     assert page.has_content?('You have successfully logged out')
    end
    visit user_path(user)
  end

  test "if user not logged in cannot see someone else's ideas" do\
    user.ideas.create(name: 'Eating Ice Cream')
    ApplicationController.any_instance.stubs(:current_user).returns(nil)
    visit user_path(user)
    assert_equal 200, page.status_code
    refute page.has_content?('Your Ideas:')
  end

  test "a logged in user cannot see someone else's ideas" do
    user2 = User.create(username: 'example2', password: 'password2')
    user.ideas.create(name: 'Eating Ice Cream')
    ApplicationController.any_instance.stubs(:current_user).returns(user2)
    visit user_path(user)
    assert_equal 200, page.status_code
    refute page.has_content?('Your Ideas:')
  end

end
