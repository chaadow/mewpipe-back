class V1::BaseController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_action :authenticate_user_from_token!

  def not_found
    return api_error(status: 404, errors: 'Not found')
  end

  ##
  # User Authentication
  # Authenticates the user with OAuth2 Resource Owner Password Credentials Grant
  def authenticate_user_from_token!
    auth_token = request.headers['Authorization']

    if auth_token
      authenticate_with_auth_token auth_token
    else
      authentication_error
    end
  end

  private

  def authenticate_with_auth_token auth_token

    user = User.find_by(auth_token: auth_token)

    if user
      # User can access
      sign_in user, store: false
    else
      authentication_error
    end
  end

  ##
  # Authentication Failure
  # Renders a 401 error
  def authentication_error
    # User's token is either invalid or not in the right format
    render json: {error: t('unauthorized')}, status: 401  # Authentication timeout
  end
end
