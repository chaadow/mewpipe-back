class V1::SessionsController < V1::BaseController

  skip_before_action :authenticate_user_from_token!

    # POST /v1/login
    def create
      # if params[:identity_url]
        authenticate_with_open_id(params[:identity_url], :required => [:nickname, :email ]) do |result, identity_url,registration|
          if result.successful?
            # FIXME - needs normalizing before
            # checking for the identity_url

            @user = User.find_or_initialize_by(identity_url: identity_url)
             if @user.new_record?
               @user.username = registration['nickname']
               @user.firstname = "Firstname openid"
               @user.lastname = "LASTname openid"
               @user.email = registration['email']
               @user.save
               @user.reload
               redirect_to "http://localhost:3000/#/redirect/#{@user.id}/#{@user.auth_token}"
               return false
             end
            # unless user = User.find_by(identity_url: identity_url)
            #   user = User.create(identity_url: identity_url)
            # end
            # sign_in :user, user

              redirect_to "http://localhost:3000/#/error"
            return
            # render json: user, serializer: V1::SessionSerializer, root: "session"
          else
            render json: "ERROR INSIDE OPEN ID"
          end
        end
      # else
      #   @user = User.find_for_database_authentication(email: params[:email])
      #   return invalid_login_attempt unless @user
      #
      #   if @user.valid_password?(params[:password])
      #     sign_in :user, @user
      #     render json: @user, serializer: V1::SessionSerializer, root: "session"
      #   else
      #     invalid_login_attempt
      #   end
      # end
    end

    private

    def invalid_login_attempt
      warden.custom_failure!
      render json: {error: "Invalid login attempt"}, status: :unprocessable_entity
    end

end
