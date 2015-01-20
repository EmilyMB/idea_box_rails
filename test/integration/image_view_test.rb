require 'test_helper'

class ImageViewTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :admin
  #
  def setup
    @admin = User.create(username: 'admin', password: 'password2', role: "admin")
    #visit root_url
  end

  test 'a logged in admin can see existing images' do
    image = Image.create(link: "www.food.com")
    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit images_path
    within('#images') do
      assert page.has_content?('Current Images:')
      assert page.has_content?('www.food.com')
    end
  end

  test 'a logged in user cannot see existing images' do
    skip
    user = User.create(username: 'bob4', password: 'bob4')
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit images_path
    refute page.has_content?('Current Images:')
  end

  test 'a not authenticated user cannot see existing images' do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(nil)
    visit images_path
    refute page.has_content?('Current Images:')
  end

  test 'a logged in admin can create images' do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit images_path
    click_link_or_button 'Add Image'
    #assert_redirected_to new_image_path
  end

  test 'a logged in admin can destroy images' do
    skip
    image = Image.create(name: "Food3", id:15)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit images_path
    click_link_or_button ('delete_cat_15')

    within('#flash_message') do
      assert page.has_content?('Image deleted')
    end

    refute page.has_content?("Food3")
  end

end
