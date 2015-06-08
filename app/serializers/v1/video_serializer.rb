class V1::VideoSerializer < V1::BaseSerializer
  attributes :id, :title, :description, :confidentiality, :user_id, :file, :created_at, :updated_at

  # belongs_to :user
end
