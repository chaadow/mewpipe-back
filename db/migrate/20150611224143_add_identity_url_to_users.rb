class AddIdentityUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :indentity_url, :string
    add_index :users, :indentity_url, unique: true
  end
end
