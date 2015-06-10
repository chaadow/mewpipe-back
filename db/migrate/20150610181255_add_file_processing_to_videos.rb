class AddFileProcessingToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :file_processing, :boolean
  end
end
