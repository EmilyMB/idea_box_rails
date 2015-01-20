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
    user = User.create(username: 'bob4', password: 'bob4')
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit images_path
    refute page.has_content?('Current Images:')
  end

  test 'a not authenticated user cannot see existing images' do
    ApplicationController.any_instance.stubs(:current_user).returns(nil)
    visit images_path
    refute page.has_content?('Current Images:')
  end

  test 'a logged in admin can create images' do
    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit images_path
    click_link_or_button 'Add Image'
    assert current_path == new_image_path
    fill_in 'image_link', with: 'example.com'
    click_link_or_button 'Save image info'
    assert_equal images_path, current_path
    within('#flash_notice') do
      assert page.has_content?('Image saved.')
    end
  end

  test 'a logged in admin can destroy images' do
    image = Image.create(link: "Food3.io", id:150)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit images_path
    click_link_or_button ('delete_150')

    within('#flash_message') do
      assert page.has_content?('Image deleted')
    end

    refute page.has_content?("Food3.io")
  end

end
