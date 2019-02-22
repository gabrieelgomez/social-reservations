# Devise module authenticate

# SessionsController
Devise::SessionsController.class_eval do

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?


    if current_user.has_role?(:agent) || current_user.has_role?(:agency)
      agency = (current_user&.agency || current_user&.agent&.agency)
      unless agency.unique_code.eql?(params[:agency_code])
        sign_out
        redirect_to new_user_session_path, flash: {error: "Código de agencia incorrecto"}
      else
        respond_with resource, location: after_sign_in_path_for(resource)
      end
    else
      respond_with resource, location: after_sign_in_path_for(resource)
    end


  end

  protected

  def after_sign_in_path_for(resource)
    if resource.has_role? :client or resource.has_role? :partner
      root_path
    else
      admin_root_path
    end
  end
end
