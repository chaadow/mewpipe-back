class V1::BaseController < ApplicationController
  include Pundit

  rescue_from ActiveRecord::RecordNotFound, with: :not_found!
  rescue_from Pundit::NotAuthorizedError, with: :unauthorized!

  before_action :destroy_session
  # before_action :authenticate_user_from_token!

  attr_accessor :current_user


protected

def destroy_session
  request.session_options[:skip] = true
end

def unauthenticated!
  response.headers['WWW-Authenticate'] = "Token realm=Application"
  render json: { error: 'Bad credentials' }, status: 401
end

def unauthorized!
  render json: { error: 'not authorized' }, status: 403
end

def invalid_resource!(errors = [])
  api_error(status: 422, errors: errors)
end

def generate_url(url, params = {})
  uri = URI(url)
  uri.query = params.to_query
  uri.to_s
end

def not_found!
  return api_error(status: 404, errors: 'Not found')
end

def api_error(status: 500, errors: [])
  unless Rails.env.production?
    puts errors.full_messages if errors.respond_to? :full_messages
  end
  head status: status and return if errors.empty?

  render json: jsonapi_format(errors).to_json, status: status
end

def paginate(resource)
  resource = resource.page(params[:page] || 1)
  if params[:per_page]
    resource = resource.per(params[:per_page])
  end

  return resource
end

#expects pagination!
def meta_attributes(object)
  {
    current_page: object.current_page,
    next_page: object.next_page,
    prev_page: object.prev_page,
    total_pages: object.total_pages,
    total_count: object.total_count
  }
end

def authenticate_user!
  token, options = ActionController::HttpAuthentication::Token.token_and_options(request)

  user_email = options.blank?? nil : options[:email]
  user = user_email && User.find_by(email: user_email)

  if user && ActiveSupport::SecurityUtils.secure_compare(user.authentication_token, token)
    @current_user = user
  else
    return unauthenticated!
  end
end

private

#ember specific :/
def jsonapi_format(errors)
  return errors if errors.is_a? String
  errors_hash = {}
  errors.messages.each do |attribute, error|
    array_hash = []
    error.each do |e|
      array_hash << {message: "#{attribute} #{e}"}
    end
    errors_hash.merge!({ attribute => array_hash })
  end

  return errors_hash
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
