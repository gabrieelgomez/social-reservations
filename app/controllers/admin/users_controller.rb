# frozen_string_literal: true

module Admin
  # UsersController
  class UsersController < AdminController
    before_action :set_user, only: %i[show edit update destroy]
    before_action :set_roles, only: %i[index new edit create update assign_partner resend_email]
    before_action :show_history, only: %i[index assign_partner resend_email]
    before_action :authorization, except: %i[reload filter_by_role assign_partner resend_email]
    before_action :set_users, only: %i[index filter_by_role reload assign_partner resend_email]
    skip_before_action :verify_authenticity_token
    include ObjectQuery

    def index
      if params[:role]
        return @users = User.all.drop(1) if params[:role].eql?('all')
        @users = User.filter_by_role(@objects, params[:role])
        @rol = params[:role]
        respond_to_formats(@users)
      else
        @users = User.all.drop(1)
        @users = @users.reject{|user| user.roles.empty?}
        redirect_to_index(users_path) if nothing_in_first_page?(@objects)
        respond_to_formats(@users)
      end
    end

    def filter_by_role
    end

    def assign_partner
      user = User.find(params[:user_id])
      partner = params[:partner]
      user.add_role    :partner if partner.eql?('false')
      user.remove_role :partner if partner.eql?('true')
      # @users = User.filter_by_role(@objects, 'client')
      redirect_to admin_users_path
    end

    def resend_email
      user_ids = params[:user_ids].try(:split, ',').try(:map, &:to_i)
      @users = User.where(id: user_ids)
      delivery_emails unless @users.blank?
      redirect_to admin_users_path
    end

    def delivery_emails
      @users.each do |user|
        ReservationMailer.send_password(user).deliver_now
      end
    end

    def new
      @user = User.new
      respond_to_formats(@user)
    end

    def show; end

    def edit; end

    def update
      update_attributes = user_params.delete_if do |_, value|
        value.blank?
      end

      if @user.update_attributes(update_attributes)
        redirect(@user, params)
      else
        render action: 'edit'
      end
    end

    def create
      @user = User.new(user_params)
      @user = User.create_or_restore(@user)
      if @user.save
        @user.add_role Role.find(user_params.fetch(:role_ids)).name
        redirect(@user, params)
      else
        render 'new'
      end
    end

    def destroy
      @user.roles.destroy_all
      @user.destroy
      redirect_to admin_users_path, notice: actions_messages(@user)
    end

    def destroy_multiple
      User.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_users_path(page: @current_page, search: @query),
        notice: actions_messages(User.new)
      )
    end

    def reload; end

    private

    def set_user
      if params[:id].eql?('clients') || params[:id].eql?('admins')
        redirect_to action: :index, role: params[:id]
      else
        @user = User.find(params[:id])
      end
    end

    def set_users
      @q = User.ransack(params[:q])
      users = @q.result.where('id != ?', User.first.id)
      users = users.order(created_at: :desc)
      @objects = users.page(@current_page)
      @total = users.size
    end

    def set_roles
      all_roles = Role.all.map { |rol| [rol.name.humanize, rol.id] }
      @roles = all_roles.drop(1)
    end

    def authorization
      authorize User
    end

    def user_params
      params.require(:user).permit(
        :name, :email, :phone, :dni, :password, :password_confirmation,
        :encrypted_password, :avatar,
        driver_attributes: [:id, :timetrack]
      )
    end

    def show_history
      get_history(User)
    end

    # Get submit key to redirect, only [:create, :update]
    def redirect(object, commit)
      if commit.key?('_save')
        redirect_to admin_user_path(object), notice: actions_messages(object)
      elsif commit.key?('_add_other')
        redirect_to new_admin_user_path, notice: actions_messages(object)
      elsif commit.key?('_assing_rol')
        redirect_to admin_users_path, notice: actions_messages(object)
      end
    end
  end
end
