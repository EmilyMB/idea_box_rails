require 'test_helper'

class IdeaTest < ActiveSupport::TestCase

  test "an idea can be created" do
    assert Idea.new
  end

  test "an idea has images" do
    idea = Idea.create(name: "stuff")
    assert_equal [], idea.images.all
  end

  test "an image can be added via an idea" do
    idea = Idea.create(name: "stuff")
    idea.images.create(link: "www.bob.com")
    assert_equal 1, idea.images.all.count
    assert_equal "www.bob.com", idea.images.all.first.link
  end

end
