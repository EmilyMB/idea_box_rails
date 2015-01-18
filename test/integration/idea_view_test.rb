require 'test_helper'

class IdeaViewTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user

  def setup
    @user = User.create(username: 'example', password: 'password')
    visit root_url
  end

  test 'a logged in user can create ideas' do
    user.ideas.create(name: 'Eating Ice Cream', user_id: user.id)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit user_path(user)
    click_link_or_button 'Add Idea'
    fill_in ("Name"), with: 'Running'
    click_link_or_button ('Create Idea')
    within('#ideas') do
      assert page.has_content?('Running')
    end
  end

  

  # test 'a logged in user can create ideas' do
  #   ApplicationController.any_instance.stubs(:current_user).returns(user)
  #   visit user_path(user)
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
