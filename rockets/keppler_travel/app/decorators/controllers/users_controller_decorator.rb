Admin::UsersController.class_eval do
  before_action :set_roles

  def create
    @user = User.new(user_params)

    if params[:user][:driver]
      @user.build_driver(
        timetrack: params[:user][:driver][:timetrack],
        bank: params[:user][:driver][:bank],
        account_type: params[:user][:driver][:account_type],
        account_number: params[:user][:driver][:account_number],
        email_corporative: params[:user][:driver][:email_corporative]
      )
      @user.driver.vehicle_ids = params[:driver][:vehicle_ids].split(',').map(&:to_i)
      @user.driver.destination_id = params[:driver][:destination_id]
      if @user.save!
        @user.add_role :driver
        update_password if params[:user][:driver]
        ReservationMailer.send_password(@user).deliver_now
        # redirect_to travel.admin_travel_drivers_path
        @user.driver.vehicles.each do |vehicle|
          KepplerTravel::CarDescription.create(
            license: '',
            color: '',
            driver: @user.driver,
            vehicle: vehicle)
        end
        redirect_to travel.admin_travel_driver_description_tables_path(@user.driver)
      else
        redirect_to travel.new_admin_travel_driver_path
      end
    # -----
    # -----
    else
      @user = User.new(user_params)
      if @user.save!
        update_password
        @user.add_role Role.find(user_params.fetch(:role_ids)).name
        redirect(@user, params)
      else
        render 'new'
      end
    end
    # -----
  end

  # def update
  #   update_attributes = user_params.delete_if do |_, value|
  #     value.blank?
  #   end
  #   if params[:user][:driver]
  #     # -----
  #     if @user.driver.update(timetrack: params[:user][:driver][:timetrack])
  #       ids = params[:driver][:vehicle_ids].split(',').map(&:to_i)
  #       @user.driver.update(vehicle_ids: ids)
  #       update_password
  #       redirect_to travel.admin_travel_driver_path(@user.driver)
  #     else
  #       # redirect_to travel.new_admin_travel_driver_path
  #     end
  #     # -----
  #   else
  #     if @user.update_attributes(update_attributes)
  #       update_password
  #       redirect(@user, params)
  #     else
  #       render action: 'edit'
  #     end
  #   end
  # end

  def update_password
    return if user_params[:password].blank?
    @user.format_accessable_passwd(user_params[:password])
  end

  private

  def driver_params
    params.permit(:timetrack, :bank, :account_type, :account_number, :destination_id, :user_id, :email_corporative)
  end

  def user_params
    params.require(:user).permit(
      :name, :email, :phone, :dni, :password, :password_confirmation,
      :role_ids, :encrypted_password, :avatar,
      driver_attributes: [:id, :timetrack, :bank, :account_type, :account_number, :destination_id, :email_corporative]
    )
  end

end
