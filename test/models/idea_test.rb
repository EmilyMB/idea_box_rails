require 'test_helper'

class IdeaTest < ActiveSupport::TestCase

  test "an idea can be created" do
    assert Idea.new
  end



end
