class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :validatable


  validates :username, presence: true
  validates :email, presence: true

  before_create :set_auth_token

  private
    def set_auth_token
      return if auth_token.present?
      self.auth_token = generated_auth_token
    end

    def generate_auth_token
      SecureRandom.uuid.gsub(/\-/,'')
    end

end
