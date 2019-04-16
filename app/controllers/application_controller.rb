# ApplicationControlller -> Controller base this application
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::Serialization

  protect_from_forgery with: :null_session

  layout :layout_by_resource
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :appearance
  before_action :set_apparience_colors
  before_action :set_sidebar
  before_action :set_modules

  serialization_scope :view_context
  before_action :cors_preflight_check
  after_action :cors_set_access_control_headers

  skip_around_action :set_locale_from_url
  include Pundit
  include PublicActivity::StoreController
  include AdminHelper

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # rescue_from Faraday::ConnectionFailed do |error|
  #   redirect_to main_app.admin_users_path, notice: "Sin conexión a internet"
  # end

  private

  def class_exists?(klass)
    defined?(klass) && klass.is_a?(Class)
  end

  def appearance
    @appearance = Setting.first.appearance
  end

  def set_apparience_colors
    variables_file = File.readlines(style_file)
    @color = ""
    variables_file.each { |line| @color = line[15..21] if line.include?('$keppler-color') }
  end

  def style_file
    "#{Rails.root}/app/assets/stylesheets/admin/utils/_variables.scss"
  end

  def set_setting
    @setting = Setting.first
  end

  def user_not_authorized
    flash[:alert] = t('keppler.messages.not_authorized_action')
    redirect_to(request.referrer || root_path)
  end

  # block access dashboard
  def dashboard_access
    roles = Role.all.map {|x| x.name}
    unless !user_signed_in? || roles.include?(current_user.rol)
      raise CanCan::AccessDenied.new(
        t('keppler.messages.not_authorized_page'), :index, :dashboard
      )
    end
  end

  def set_sidebar
    @sidebar = YAML.load_file(
      "#{Rails.root}/config/menu.yml"
    ).values.each(&:symbolize_keys!)
    modules = Dir[File.join("#{Rails.root}/rockets", '*')]
    modules.each do |m|
      module_menu = YAML.load_file(
        "#{m}/config/menu.yml"
      ).values.each(&:symbolize_keys!)
      @sidebar[0] = @sidebar[0].merge(module_menu[0])
    end
  end

  def set_modules
    @modules = YAML.load_file(
      "#{Rails.root}/config/permissions.yml"
    ).values.each(&:symbolize_keys!)
    modules = Dir[File.join("#{Rails.root}/rockets", '*')]
    modules.each do |m|
      module_name = YAML.load_file(
        "#{m}/config/permissions.yml"
      ).values
      return if module_name.first.nil?
      module_name.each(&:symbolize_keys!)
      @modules[0] = @modules[0].merge(module_name[0])
    end
  end

  protected


  def cors_set_access_control_headers
    p "CORS SET ACCESS CONTROL HEADER"
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Access-Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      p "CORS PREFLIGHT CHECK"
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token, Content-Type'
      headers['Access-Control-Max-Age'] = '1728000'

      render text: '', content_type: 'text/plain'
    end
  end

  def handle_options_request
    render :text => '', :content_type => 'text/plain'
  end

  def configure_permitted_parameters
    RUBY_VERSION < "2.2.0" ? devise_old : devise_new
  end

  def layout_by_resource
    'admin/layouts/application' if devise_controller?
  end

  def devise_new
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation, roles:[]])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation, roles:[]])
  end

  def devise_old
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :email, :password, :password_confirmation,
               :current_password)
    end
  end

end
