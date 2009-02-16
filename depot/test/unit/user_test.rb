require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "user requires a name" do
    user = User.new
    assert ! user.valid?
    assert user.errors.on(:name)
  end

  test "user must have a unique name" do
    user = users(:john)
    assert user.save!
    user2 = User.new
    user2.name = "john"
    assert ! user2.valid?
    assert user2.errors.on(:name)
  end

  test "user must have password" do
    user = User.new
    user.name = "three"
    assert ! user.valid?
    assert user.errors.on(:password)
  end

  test "must be able to find user by name" do
    @user = User.find_by_name("john")
    assert_equal "john", @user.name
  end

  test "must be able to authenticate" do
    assert User.authenticate("john", "secret")
  end

  test "authentication must fail if bad password" do
    assert ! User.authenticate("john", "epicfai")
  end

  test "setting password should create encrypted hash" do
    user = User.new
    user.name = "test"
    user.salt = "pepper"
    user.password = "secret"
    user.password_confirmation = "secret"
    assert user.hashed_password
  end

  test "must not delete the last user" do
    assert_raise RuntimeError do
      @users = User.find(:all)
      for user in @users
        user.destroy
      end
    end
  end
end
