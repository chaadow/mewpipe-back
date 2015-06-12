class V1::SessionsController < V1::BaseController

  skip_before_action :authenticate_user_from_token!

    # POST /v1/login
    def create
      if params[:identity_url]
        authenticate_with_open_id(params[:identity_url]) do |result, identity_url|
          if result.successful?
            # FIXME - needs normalizing before
            # checking for the identity_url
            unless user = User.find_by(identity_url: identity_url)
              user = User.create(identity_url: identity_url)
            end
            sign_in user
          else
            invalid_login_attempt
          end
        end
      else
        @user = User.find_for_database_authentication(email: params[:email])
        return invalid_login_attempt unless @user

        if @user.valid_password?(params[:password])
          sign_in :user, @user
          render json: @user, serializer: V1::SessionSerializer, root: "session"
        else
          invalid_login_attempt
        end
      end
    end

    private

    def invalid_login_attempt
      warden.custom_failure!
      render json: {error: "Invalid login attempt"}, status: :unprocessable_entity
    end

end
