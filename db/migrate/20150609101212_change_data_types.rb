class ChangeDataTypes < ActiveRecord::Migration
  def change
    remove_column :videos, :file_meta
    add_column :videos, :file_meta, :text
  end
end
