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
    assert current_path == new_category_path
    fill_in 'category[name]', with: 'mountain biking'
    click_link_or_button ('Create category')
    assert_equal categories_path, current_path
    within('#flash_notice') do
      assert page.has_content?('Category was successfully created.')
    end
  end

  test 'a logged in admin can destroy categories' do
    category = Category.create(name: "Food3", id:15)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit categories_path
    click_link_or_button ('delete_cat_15')

    within('#flash_message') do
       assert page.has_content?('Category deleted')
    end

    refute page.has_content?("Food3")
  end

end
