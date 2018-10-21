# Application Policy
class ControllerPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, objects)
    @user = user
    @objects = objects
  end

  def index?
    admin? || keppler_admin? || user_can?(@objects, 'index')
  end

  def new?
    create? || user_can?(@objects, 'create')
  end

  def create?
    admin? || keppler_admin? || user_can?(@objects, 'create')
  end

  def edit?
    update? || user_can?(@objects, 'update')
  end

  def update?
    admin? || keppler_admin? || user_can?(@objects, 'update')
  end

  def clone?
    admin? || keppler_admin? || user_can?(@objects, 'clone')
  end

  def show?
    admin? || keppler_admin? || user_can?(@objects, 'index')
  end

  def destroy_multiple?
    destroy?
  end

  def destroy?
    admin? || keppler_admin? || user_can?(@objects, 'destroy')
  end

  def upload?
    admin? || keppler_admin? || user_can?(@objects, 'upload')
  end

  def download?
    admin? || keppler_admin? || user_can?(@objects, 'download')
  end

  def sort?
    admin? || keppler_admin? || user_can?(@objects, 'sort')
  end
end
