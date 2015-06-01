class V1::UserSerializer < V1::BaseSerializer
  attributes :id, :email, :username, :admin, :created_at, :updated_at

  has_many :videos


end
