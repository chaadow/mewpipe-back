class V1::UsersController < V1::BaseController

  include ActiveHashRelation

  def index
    users = User.all

    users = apply_filters(users, params)

    render(
      json: ActiveModel::ArraySerializer.new(
        users,
        each_serializer: Api::V1::UserSerializer,
        root: 'users',
      )
    )
  end
end
