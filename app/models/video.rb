class Video < ActiveRecord::Base

  # Scopes
  scope :recent, -> { order('created_at DESC') }

  scope :listed, -> { where("lower(confidentiality) = ?", "public")}
  scope :unlisted, -> { where("lower(confidentiality) = ?", "privatelink")}
  scope :personal, -> { where("lower(confidentiality) = ?", "private") }


  # Add tags
  acts_as_taggable

  # Associations
  belongs_to :user

  has_attached_file :file, :styles => {
    :mp4 => { :geometry => "640x480", :format => 'mp4'},
    :ogg => { :geometry => "640x480#", :format => 'ogg'},
    :webm => { :geometry => "640x480#", :format => 'webm'},

    :thumb => { :geometry => "300x300#", :format => 'jpg', :time => 10 },
    :small => { :geometry => "242x137#", :format => 'jpg', :time => 10 },
    :poster => { :geometry => "1000x750", :format => 'jpg', :time => 10 }
  }, :processors => [:transcoder]

  # Validations
  validates :title,  presence: true

  validates_attachment :file, :presence => true,
                       :content_type => { :content_type => ["video/mp4", "video/x-flv", "video/ogg", "video/webm"]},
                       :size => { :in => 0..500.megabytes }
end
