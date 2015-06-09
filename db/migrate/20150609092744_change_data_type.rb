class ChangeDataType < ActiveRecord::Migration
  def change
    remove_column :videos, :file_meta
    add_column :videos, :file_meta, :hstore
  end
end
