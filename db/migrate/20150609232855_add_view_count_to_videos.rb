class AddViewCountToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :view_count, :integer, null: false, default: 0
  end
end
