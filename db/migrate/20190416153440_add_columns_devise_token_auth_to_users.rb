class AddColumnsDeviseTokenAuthToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string, null: false, default: 'email', index: true, unique: true
    add_column :users, :uid, :string, null: false, default: '', index: true, unique: true
    add_column :users, :custom_token, :string
    add_column :users, :confirmation_token, :string, index: true, unique: true
    add_column :users, :unconfirmed_email, :string
    add_column :users, :allow_password_change, :string, default: false

    add_column :users, :request_change_password, :datetime
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime

    add_column :users, :tokens, :json
  end
end
