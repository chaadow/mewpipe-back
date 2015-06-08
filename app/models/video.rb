class Video < ActiveRecord::Base

  # Scopes
  scope :recent, -> { order('created_at DESC') }

  # Associations
  belongs_to :user

  has_attached_file :file, :styles => {
    :medium => { :geometry => "640x480", :format => 'flv' },
    :thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10 }
  }, :processors => [:transcoder]

  # Validations
  validates :title, :description, presence: true

  validates_attachment :file, :presence => true,
                       :content_type => { :content_type => ["video/mp4", "video/x-flv", "image/jpg", "image/jpeg", "image/png", "image/gif"]},
                       :size => { :in => 0..500.megabytes }
end
