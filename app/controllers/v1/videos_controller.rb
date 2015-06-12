class V1::VideosController < V1::BaseController

  include ActiveHashRelation

  def index

    videos = Video.all
    # binding.pry 
    videos = apply_filters(videos, params)

    videos = videos.tagged_with(params[:tag_list]) if params[:tag_list]

    videos = paginate(videos)

    render(
    json:
      videos,
      each_serializer: V1::VideoSerializer,
      root: 'videos',
      meta: meta_attributes(videos)

    )
  end

  def show
    video = Video.friendly.find(params[:id])
    impressionist(video)


    render(json: video, root: "video", serializer: V1::VideoSerializer)
  end

  def new
    video = Video.new
  end

  def upload
    video = Video.new(video_params)
    return api_error(status: 422, errors: video.errors) unless video.valid?
    video.save!

    render(
      json: video, serializer: V1::VideoSerializer,
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
    video = Video.friendly.find(params[:id])
    # user = User.find(params[:user_id])
    # authorize user

    unless video.update_attributes(update_params)
      return api_error(status: 422, errors: video.errors)
    end

    render(
      json:  video, serializer: V1::VideoSerializer,
      status: 200,
      location: v1_video_path(video.id)
    )
  end

  def destroy
    video = Video.find(params[:id])

    api_error(status:500) unless video.destroy

    head status: 204
  end

  def increment_view
    video = Video.friendly.find(params[:id])
    unless video.increment!(:view_count)
      api_error(status:422, errors: "The view can not be incremented")
    end

    render(
      json: {count: video.view_count},
      status: 200,
      location: v1_video_path(video.id)
    )


  end


  private

  def video_params
    params.permit(:title, :description, :confidentiality, :file, :user_id, :tag_list, :property, :order)
  end

  def update_params
    video_params
  end

end
