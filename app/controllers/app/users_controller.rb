module App
  # FrontsController
  class UsersController < DashboardController
    layout 'layouts/templates/application'
    before_action :set_user, only: %i[update]

    def update
      # byebug
      # update_attributes = user_params.delete_if do |_, value|
      #   value.blank?
      # end
      #
      # if @user.update_attributes(update_attributes)
      #   redirect(@user, params)
      # else
      #   render action: 'edit'
      # end
    end

    private

    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(
        :name, :email, :password, :password_confirmation,
        :role_ids, :encrypted_password, :avatar
      )
    end

  end
end
