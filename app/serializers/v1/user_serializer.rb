class V1::UserSerializer < V1::BaseSerializer
  attributes :id, :email, :firstname, :lastname, :admin, :created_at, :updated_at, :file

  #has_many :videos


end
