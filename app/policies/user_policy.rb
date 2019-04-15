# frozen_string_literal: true

# Policy for user model
class UserPolicy < ControllerPolicy
  attr_reader :user, :objects

  def initialize(user, objects)
    @user = user
    @objects = objects
  end

  def clone?
    false
  end

  def assign_partner?
    true
  end

  def resend_email?
    true
  end

  def destroy?
    keppler_admin? && !same_user?(@user)
  end
end
