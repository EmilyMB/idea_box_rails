require 'test_helper'

class CategoryCRUDTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :admin
  #
  def setup
    @admin = User.create(username: 'admin', password: 'password2', role: "admin")
    #visit root_url
  end

  test 'a logged in admin can see existing categories' do
    admin = User.create(username: 'admin', password: 'password2', role: "admin")
    category = Category.create(name: "Food")
    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit categories_path
    within('#idea_categories') do
      assert page.has_content?('Current Categories:')
      assert page.has_content?('Food')
    end
  end

  test 'a logged in user cannot see existing categories' do
    user = User.create(username: 'bob4', password: 'bob4')
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit categories_path
    refute page.has_content?('Current Categories:')
  end

  test 'a not authenticated user cannot see existing categories' do
    ApplicationController.any_instance.stubs(:current_user).returns(nil)
    visit categories_path
    refute page.has_content?('Current Categories:')
  end

  test 'a logged in admin can create categories' do
    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit categories_path
    click_link_or_button 'Add Category'
    assert_redirected_to new_category_path
  end

  # test 'user can login with valid credentials' do
  #  fill_in 'session[username]', with: 'example'
  #  fill_in 'session[password]', with: 'password'
  #  click_link_or_button 'Login'
  #
  #  assert_equal user_path(user), current_path
  #  within('#flash_messages') do
  #    assert page.has_content?('You have successfully logged in')
  #  end
  # end
  #
  # test 'a logged in user can see their ideas' do
  #   user.ideas.create(name: 'Eating Ice Cream')
  #   ApplicationController.any_instance.stubs(:current_user).returns(user)
  #   visit user_path(user)
  #   within('#ideas') do
  #     assert page.has_content?('Your Ideas:')
  #     assert page.has_content?('Eating Ice Cream')
  #   end
  # end
  #
  # test 'a user can log out' do
  #   ApplicationController.any_instance.stubs(:current_user).returns(user)
  #   visit user_path(user)
  #   click_link_or_button('Logout')
  #   within('#flash_messages') do
  #    assert page.has_content?('You have successfully logged out')
  #   end
  #   visit user_path(user)
  # end
  #
  # test "if user not logged in cannot see someone else's ideas" do\
  #   user.ideas.create(name: 'Eating Ice Cream')
  #   ApplicationController.any_instance.stubs(:current_user).returns(nil)
  #   visit user_path(user)
  #   assert_equal 200, page.status_code
  #   refute page.has_content?('Your Ideas:')
  # end
  #
  # test "a logged in user cannot see someone else's ideas" do
  #   user2 = User.create(username: 'example2', password: 'password2')
  #   user.ideas.create(name: 'Eating Ice Cream')
  #   ApplicationController.any_instance.stubs(:current_user).returns(user2)
  #   visit user_path(user)
  #   assert_equal 200, page.status_code
  #   refute page.has_content?('Your Ideas:')
  # end
  #
  # test "an admin user can see someone else's ideas" do
  #   admin = User.create(username: 'admin', password: 'password2', role: "admin")
  #   user.ideas.create(name: 'Eating Ice Cream')
  #   ApplicationController.any_instance.stubs(:current_user).returns(admin)
  #   visit user_path(user)
  #   assert_equal 200, page.status_code
  #   within('#ideas') do
  #     assert page.has_content?('Your Ideas:')
  #     assert page.has_content?('Eating Ice Cream')
  #   end
  # end

end
