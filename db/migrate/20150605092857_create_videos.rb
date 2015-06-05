class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :description
      t.string :confidentiality, default: 'public'
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
