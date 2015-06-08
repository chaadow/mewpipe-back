class V1::VideosController < V1::BaseController

  before_action :find_video, only: [:show, :edit, :update, :destroy]

  include ActiveHashRelation

  def index
    videos = Video.all

    videos = apply_filters(videos, params)

    videos = paginate(videos)

    render(
    json: ActiveModel::ArraySerializer.new(
      videos,
      each_serializer: V1::VideoSerializer,
      root: 'videos',
      meta: meta_attributes(videos)
      )
    )
  end

  def show
    video = Video.find(params[:id])

    render(json: V1::VideoSerializer.new(video).to_json)
  end

  def new
    video = Video.new
  end

  def upload
    video = Video.new(video_params)
    return api_error(status: 422, errors: video.errors) unless video.valid?
    video.save!

    render(
      json: V1::VideoSerializer.new(video).to_json,
      status: 201,
      location: v1_video_path(video.id)
    )
  end

  def create
    video = Video.new(video_params)
    if video.save
      redirect_to video
    else
      render 'new'
    end
  end

  def edit
    video = Video.find(params[:id])
  end

  def update
    video = Video.find(params[:id])
    if video.update(video_params)
      redirect_to video
    else
      render 'edit'
    end

    render(
      json: V1::VideoSerializer.new(video).to_json,
      status: 200,
      location: _v1_video_path(video.id),
      serializer: V1::VideoSerializer
    )
  end

  def destroy
    video = Video.find(params[:id])

    api_error(status:500) unless video.destroy

    head status: 204
  end


  private

  def video_params
    params.permit(:title, :description, :confidentiality, :file, :user_id, :tag_list)
  end

  def find_video
    video = Video.find(params[:id])
  end
end
