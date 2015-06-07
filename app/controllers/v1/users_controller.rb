class V1::UsersController < V1::BaseController

  include ActiveHashRelation

  def index

    users = User.all.order(created_at: :asc)

    users = apply_filters(users, params)

    users = paginate(users)

    users = policy_scope(users)

    render(
      json: ActiveModel::ArraySerializer.new(
        users,
        each_serializer: V1::UserSerializer,
        root: 'users',
        meta: meta_attributes(users)
      )
    )
  end

  def show
    user = User.find(params[:id])
    # authorize user

    render(json: V1::UserSerializer.new(user).to_json)
  end

  def create

    avatar = params[:avatar]

    # the avatar parameter needs to be converted to a
    # hash that paperclip understands as:
    user = User.new(create_params)
    if avatar
      attachment = {
          :filename => avatar[:filename],
          :type => avatar[:type],
          :headers => avatar[:head],
          :tempfile => avatar[:tempfile]
      }
      user.avatar = ActionDispatch::Http::UploadedFile.new(attachment)

      user.avatar_path = attachment[:filename] if avatar
    end




    return api_error(status: 422, errors: user.errors) unless user.valid?

    user.save!
    #user.activate

    render(
      json: V1::UserSerializer.new(user).to_json,
      status: 201,
      location: v1_user_path(user.id)
    )
  end

  def update
    user = User.find(params[:id])
    authorize user

    if !user.update_attributes(update_params)
      return api_error(status: 422, errors: user.errors)
    end

    render(
      json: V1::UserSerializer.new(user).to_json,
      status: 200,
      location: _v1_user_path(user.id),
      serializer: V1::UserSerializer
    )
  end

  def destroy
    user = User.find(params[:id])
    authorize user

    if !user.destroy
      return api_error(status: 500)
    end

    head status: 204
  end

  private

  def create_params
    params.permit(
      :email, :password, :password_confirmation, :firstname, :lastname, :avatar
    ).delete_if{ |k,v| v.nil?}
  end
  def update_params
    create_params
  end
end
