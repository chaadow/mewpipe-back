class AddAuthTokenAndUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_token, :string
    add_index :users, :auth_token, unique: true
    add_column :users, :username, :string
    add_index :users, :username, unique: true
  end
end
