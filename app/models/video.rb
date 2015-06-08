class Video < ActiveRecord::Base

  # Scopes
  scope :recent, -> { order('created_at DESC') }

  # Associations
  belongs_to :user

  has_attached_file :file

  # Validations
  validates :title, :description, presence: true

  validates_attachment :file, :presence => true,
                       :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]},
                       :size => { :in => 0..500.megabytes }
end
