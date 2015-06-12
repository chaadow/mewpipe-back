class V1::SessionsController < V1::BaseController

  skip_before_action :authenticate_user_from_token!

    # POST /v1/login
    def create
      # binding.pry
      if params[:identity_url] || !params["password"]
        open_id_authentication(params[:identity_url])
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

    def open_id_authentication(identity_url)
  # Pass optional :required and :optional keys to specify what sreg fields you want.
  # Be sure to yield registration, a third argument in the
  # #authenticate_with_open_id block.
      authenticate_with_open_id(identity_url,
          :required => [ :nickname, :email,"http://axschema.org/contact/email", "http://axschema.org/namePerson/friendly" ],
          :optional => :fullname) do |result, identity_url, registration, ax|
        case result.status
        when :missing
          failed_login "Sorry, the OpenID server couldn't be found"
        when :invalid
          failed_login "Sorry, but this does not appear to be a valid OpenID"
        when :canceled
          failed_login "OpenID verification was canceled"
        when :failed
          failed_login "Sorry, the OpenID verification failed"
        when :successful


          if @user = User.find_or_initialize_by(identity_url: identity_url)
            if @user.new_record?
              assign_registration_attributes!(registration)

              assign_ax_attributes!(ax)
              @user.password = "password"
              if @user.save
                # binding.pry
                successful_login
              else
                failed_login "Your OpenID profile registration failed: " +
                  @user.errors.full_messages.to_sentence
              end
            else
              successful_login
            end
          end
        end
      end
    end

    # registration is a hash containing the valid sreg keys given above
    # use this to map them to fields of your user model
    def assign_registration_attributes!(registration)
      model_to_registration_mapping.each do |model_attribute, registration_attribute|
        unless registration[registration_attribute].blank?
          @user.send("#{model_attribute}=", registration[registration_attribute])
        end
      end
    end
    def assign_ax_attributes!(ax)
      model_to_ax_mapping.each do |model_attribute, ax_attribute|
        unless ax[ax_attribute].blank?
          # if ax[ax_attribute].is_a? Array
          #   ax[ax_attribute] = ax[ax_attribute].first
          # end
          @user.send("#{model_attribute}=", ax[ax_attribute])
        end
      end
    end

    def model_to_registration_mapping
      { :username => 'nickname', :email => 'email', :firstname => 'fullname' }
    end
    def model_to_ax_mapping
      { :username => 'http://axschema.org/namePerson/friendly', :email => 'http://axschema.org/contact/email' }
    end

    def successful_login
      # binding.pry
      redirect_to "http://localhost:3000/#/redirect/#{@user.id}/#{@user.auth_token}/"
    end
    def failed_login(message)
      redirect_to "http://localhost:3000/#/redirect///#{message}"
    end

    def invalid_login_attempt
      warden.custom_failure!
      render json: {error: "Invalid login attempt"}, status: :unprocessable_entity
    end

end
