class Video < ActiveRecord::Base

  # Scopes
  scope :recent, -> { order('created_at DESC') }

  # Associations
  belongs_to :user

  has_attached_file :file, :path => ":rails_root/public/files/:filename"

end
