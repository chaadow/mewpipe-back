class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :validatable,
  :openid_authenticatable

  # Validations
  validates :email, :firstname, :lastname, presence: true

  # Callbacks
  before_create :set_auth_token

  has_many :videos, dependent: :destroy


  has_attached_file :avatar,
    :styles => { :thumbnail => "150x150#" },
    :default => "/user-icon.png"
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]


  OPEN ID

  def self.openid_required_fields
  ["fullname", "email", "http://axschema.org/namePerson", "http://axschema.org/contact/email"]
end

def self.openid_optional_fields
  ["gender", "http://axschema.org/person/gender"]
end
  def openid_fields=(fields)
  fields.each do |key, value|
    # Some AX providers can return multiple values per key
    if value.is_a? Array
      value = value.first
    end

    case key.to_s
    when "fullname", "http://axschema.org/namePerson"
      self.name = value
    when "email", "http://axschema.org/contact/email"
      self.email = value
    when "gender", "http://axschema.org/person/gender"
      self.gender = value
    else
      logger.error "Unknown OpenID field: #{key}"
    end
  end
end
  # Private methods
  private
    def set_auth_token
      return if auth_token.present?
      self.auth_token = generate_auth_token
    end

    def generate_auth_token
      SecureRandom.uuid.gsub(/\-/,'')
    end

end
