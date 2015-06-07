class ChangeFileNameToAvatar < ActiveRecord::Migration
  def change
    remove_attachment :users, :file
    add_attachment :users, :avatar
  end
end
