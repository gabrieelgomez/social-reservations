# Devise module authenticate

# SessionsController
Devise::SessionsController.class_eval do

  protected

  def after_sign_in_path_for(resource)
    if resource.has_role? :client or resource.has_role? :partner
      root_path
    else
      admin_root_path
    end
  end
end
