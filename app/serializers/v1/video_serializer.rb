class V1::VideoSerializer < V1::BaseSerializer
  attributes :id, :title, :description, :confidentiality, :thumb,
             :mp4, :file, :file_meta, :created_at, :updated_at,
             :tag_list, :ogg, :webm, :view_count, :slug, :small, :poster,
             :page_views


  belongs_to :user

  def page_views
    object.impressionist_count
  end
  def thumb
    object.file.url(:thumb)
  end
  def small
    object.file.url(:small)
  end
  def poster
    object.file.url(:poster)
  end
  def mp4

    object.file_content_type == "video/mp4" ? object.file : object.file.url(:mp4)
  end
  def ogg
    object.file_content_type == "video/ogg" ? object.file : object.file.url(:ogg)
  end
  def webm
    object.file_content_type == "video/webm" ? object.file : object.file.url(:webm)
  end

  def file_meta
    JSON.parse((eval(object.file_meta)).to_json ) if object.file_meta?
  end
  # belongs_to :user
end
