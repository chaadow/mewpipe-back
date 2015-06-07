class ChangeFileName < ActiveRecord::Migration
  def change
    remove_attachment :users, :avatar
    add_attachment :users, :file
  end
end
