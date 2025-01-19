require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should save user without name" do
    user = User.new(email: "test@example.com")
    assert_not user.save, "Saved the user without a name"
  end
  test "should not save user without email" do
    user = User.new(name: "test")
    assert_not user.save, "Saved the user without an email"
  end
end
