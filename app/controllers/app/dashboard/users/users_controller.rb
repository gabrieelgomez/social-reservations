module App
  module Dashboard
    module Users
    
      class UsersController < DashboardController
        before_action :set_user, only: %i[update]

        def update
          update_attributes = user_params.delete_if do |_, value|
            value.blank?
          end
          if current_user.update_attributes(update_attributes)
            update_password
            redirect_to users_details_path, notice: 'success'
          else
            render action: 'users'
          end
        end

        def update_password
          return if user_params[:password].blank?
          current_user.format_accessable_passwd(user_params[:password])
        end

        private

        def set_user
          @user = current_user
        end

        def user_params
          params.require(:user).permit(
            :name, :username, :dni, :email, :phone, :avatar,
            :password, :password_confirmation, :encrypted_password
          )
        end

      end
    
    end
  end
end
