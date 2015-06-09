class V1::VideoSerializer < V1::BaseSerializer
  attributes :id, :title, :description, :confidentiality, :thumb,
             :mp4, :user_id, :file, :file_meta, :created_at, :updated_at,
             :tag_list


  def thumb
    object.file.url(:thumb)
  end
  def mp4
    object.file.url(:mp4)
  end

  def file_meta
    JSON.parse((eval(object.file_meta)).to_json )
  end
  # belongs_to :user
end
