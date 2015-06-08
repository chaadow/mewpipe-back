class Video < ActiveRecord::Base

  # Scopes
  scope :recent, -> { order('created_at DESC') }

  # Associations
  belongs_to :user

  has_attached_file :file, :styles => {
    :medium => { :geometry => "640x480", :format => 'flv' },
    :mp4 => { :geometry => "400x300", :format => 'mp4'},

    :thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10 }
  }, :processors => [:transcoder]

  # Validations
  validates :title,  presence: true

  validates_attachment :file, :presence => true,
                       :content_type => { :content_type => ["video/mp4", "video/x-flv"]},
                       :size => { :in => 0..500.megabytes }
end
