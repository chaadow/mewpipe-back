class V1::UserSerializer < V1::BaseSerializer

  cache key: 'users', expires_in: 3.hours

  attributes :id, :email, :firstname, :lastname, :admin, :created_at, :updated_at, :avatar, :username

  has_many :videos, serializer: V1::VideoSerializer


  def include_associations!
    include! :videos unless @options[:dont_embed_friends]
  end
end
