class Video < ActiveRecord::Base

  # For page views
  is_impressionable counter_cache: true, unique: :request_hash

  # Scopes
  scope :recent, -> { order('created_at DESC') }

  scope :listed, -> { where("lower(confidentiality) = ?", "public")}
  scope :unlisted, -> { where("lower(confidentiality) = ?", "privatelink")}
  scope :personal, -> { where("lower(confidentiality) = ?", "private") }


  extend FriendlyId
  friendly_id :title, use: :slugged
  # Add tags
  acts_as_taggable

  # Associations
  belongs_to :user

  has_attached_file :file, :styles => {
    :mp4 => { :geometry => "640x480", :format => 'mp4'},
    :ogg => { :geometry => "640x480#", :format => 'ogg'},
    :webm => { :geometry => "640x480#", :format => 'webm'},

    :thumb => { :geometry => "600x600#", :format => 'jpg', :time => 10 },
    :small => { :geometry => "242x137#", :format => 'jpg', :time => 10 },
  }, :processors => [:transcoder], only_process: [:thumb, :small]

  process_in_background :file, processing_image_url: :processing_image_fallback, only_process: [:webm, :ogg, :mp4]

  def processing_image_fallback
    options = file.options
    options[:interpolator].interpolate(options[:url], file, :original)
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end


  # Validations
  validates :title,  presence: true

  validates_attachment :file, :presence => true,
                       :content_type => { :content_type => ["video/mp4", "video/x-flv", "video/ogg", "video/webm"]},
                       :size => { :in => 0..500.megabytes }
end
