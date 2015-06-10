class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :validatable

  # Validations
  validates :email, :firstname, :lastname, presence: true

  # Callbacks
  before_create :set_auth_token

  has_many :videos, dependent: :destroy


  has_attached_file :avatar,
    :styles => { :thumbnail => "150x150#" },
    :default => "/user-icon.png"
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

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
