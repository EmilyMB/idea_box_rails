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


  test 'a logged in user can delete ideas' do
    user.ideas.create(name: 'Eating Ice Cream', user_id: user.id)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit user_path(user)
    click_link_or_button ('Delete')
    within('#ideas') do
      refute page.has_content?('Eating Ice Cream')
    end
  end

  test 'a logged in user can edit an idea' do
    user.ideas.create(name: 'Eating Ice Cream', user_id: user.id)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit user_path(user)
    click_link_or_button ('Edit')
    fill_in ("Name"), with: 'Eating Ice Cream Cones'
    click_link_or_button ('Update Idea')
    within('#ideas') do
      assert page.has_content?('Eating Ice Cream Cones')
    end
  end


  test "a logged in user cannot edit someone else's ideas" do
    new_idea = user.ideas.create(name: 'Eating Ice Cream', user_id: user.id)
    user2 = User.create(username: 'example2', password: 'password2')
    ApplicationController.any_instance.stubs(:current_user).returns(user2)
    visit edit_idea_path(new_idea.id)
    refute page.has_content?('Edit')
  end

  test "a logged in user cannot delete someone else's ideas" do
    new_idea = user.ideas.create(name: 'Eating Ice Cream', user_id: user.id)
    user2 = User.create(username: 'example2', password: 'password2')
    ApplicationController.any_instance.stubs(:current_user).returns(user2)
    page.driver.submit :delete, "/ideas/#{new_idea.id}", {}
    refute page.has_content?('Edit')
  end

  test "a not logged in user cannot edit someone else's ideas" do
    new_idea = user.ideas.create(name: 'Eating Ice Cream', user_id: user.id)
    ApplicationController.any_instance.stubs(:current_user).returns(nil)
    visit edit_idea_path(new_idea.id)
    refute page.has_content?('Edit')
  end

  test "a logged in user can select a category when creating an idea" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit user_path(user)
    click_link_or_button 'Add Idea'
    fill_in ("Name"), with: 'Running'
  #  find('idea_categories').find(:xpath, 'option[2]').select_option
    #find_field('restrictions__rating_movies').find('option[selected]').text
    click_link_or_button ('Create Idea')
  end

  test 'a logged in user can add images to an idea' do
  #  user.ideas.create(name: 'Eating Ice Cream', user_id: user.id)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit user_path(user)
    click_link_or_button 'Add Idea'
    fill_in ("Name"), with: 'Running'
    fill_in ('idea[images_attributes][0][link]'), with: "http://www.google.com"
    click_link_or_button ('Create Idea')
    within('#ideas') do
      assert page.has_content?('http://www.google.com')
    end
  end
end



#
# Images:
# <%= f.fields_for :images do |images_form| %>
#   <li>
#   <%= images_form.label "Image Link" %>
#   <%= images_form.collection_select(:link, Image.all, :id, :link)%>
#   </li>
#   <% end %>
#
#
# # <%= f.label "Image Link" %>
# <%= select_tag("idea.images[link][]", options_for_select(Image.all.collect{| image| [image.link, image.id] }, @idea.images.collect { |image| image.id}), {:multiple =>true, :size => 3,  :prompt => true}) %>
