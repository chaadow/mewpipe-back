class V1::VideoSerializer < V1::BaseSerializer
  attributes :id, :title, :description, :confidentiality, :thumb, :mp4, :user_id, :file, :file_meta, :created_at, :updated_at


  def thumb
    object.file.url(:thumb)
  end
  def mp4
    object.file.url(:mp4)
  end
  # belongs_to :user
end
