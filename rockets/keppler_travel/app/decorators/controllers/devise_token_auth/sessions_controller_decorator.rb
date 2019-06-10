# Devise module authenticate

# SessionsController
DeviseTokenAuth::SessionsController.class_eval do

  def create
    # Check
    field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first

    @resource = nil
    if field
      q_value = get_case_insensitive_field_from_resource_params(field)

      @resource = find_resource(field, q_value)
    end

    if current_user.has_role?(:agent) || current_user.has_role?(:agency)
      agency = (current_user&.agency || current_user&.agent&.agency)
      if agency.unique_code.eql?(params[:agency_code])

        @client_id, @token = @resource.create_token
        @resource.save

        sign_in(:user, @resource, store: false, bypass: false)

        yield @resource if block_given?

        render_create_success
      else
        return render_error(404, 'Código de agencia incorrecto')
      end

    elsif @resource && valid_params?(field, q_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
      valid_password = @resource.valid_password?(resource_params[:password])
      if (@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? { valid_password }) || !valid_password
       return render_create_error_bad_credentials
      end
      @client_id, @token = @resource.create_token
      @resource.save

      sign_in(:user, @resource, store: false, bypass: false)

      yield @resource if block_given?

      render_create_success
    elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
      if @resource.respond_to?(:locked_at) && @resource.locked_at
        render_create_error_account_locked
      else
        render_create_error_not_confirmed
      end
    else
      render_create_error_bad_credentials
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
