class V1::UserSerializer < V1::BaseSerializer
  attributes :id, :email, :name,  :activated, :admin, :created_at, :updated_at

  has_many :videos

  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end
