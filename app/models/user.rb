# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  include ActivityHistory
  # mount_uploader :avatar, TemplateUploader
  before_save :create_permalink, if: :new_record?
  rolify
  validates_presence_of :name, :email #role_ids
  mount_uploader :avatar, AttachmentUploader
  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def rol
    roles.first.&name
  end

  def permissions?
    roles.first.permissions?
  end

  def self.filter_by_role(obj, role)
    obj.select { |u| u.has_role? role.to_sym }
  end

  # Get the page number that the object belongs to
  def page(order = :id)
    ((self.class.order(order => :desc)
      .pluck(order).index(send(order)) + 1)
        .to_f / self.class.default_per_page).ceil
  end

  def self.search_field
    :name_or_username_or_email_cont
  end

  def keppler_admin?
    rol.eql?('keppler_admin')
  end

  def admin?
    rol.eql?('admin')
  end

  def can?(model_name, method)
    return if permissions.nil? || permissions[model_name].nil?
    permissions[model_name]['actions'].include?(method) || false
  end

  def permissions
    return if roles.first.permissions.blank?
    roles.first.permissions.first.modules
  end

  def format_accessable_passwd(psswd)
    set_env_var
    encrypted_data = @crypt.encrypt_and_sign(psswd)
    update(accessable_password: encrypted_data)
  end

  def real_password
    set_env_var
    @crypt.decrypt_and_verify(accessable_password)
  end

  private

  def set_env_var
    key        = Rails.application.secrets[:key]
    salt       = Rails.application.secrets[:salt]
    passphrase = ActiveSupport::KeyGenerator.new(key).generate_key(salt, 32)
    @crypt     = ActiveSupport::MessageEncryptor.new(passphrase)
  end

  def create_permalink
    self.permalink = name.downcase.parameterize + '-' + SecureRandom.hex(4)
  end
end
