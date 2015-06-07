class V1::SessionSerializer < ActiveModel::Serializer

    attributes :email, :token_type, :user_id, :token, :admin, :avatar, :first_name, :last_name

    def user_id
      object.id
    end

    def token_type
      'Bearer'
    end

    def token
      object.auth_token
    end

end
