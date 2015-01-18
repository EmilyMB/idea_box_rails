require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "a user has no ideas to start" do
    user = User.new(username: "bob3", role: 1)
    assert_equal [], user.ideas
  end
end
