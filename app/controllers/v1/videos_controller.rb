class V1::VideosController < V1::BaseController

  before_action :find_video, [:show, :edit, :update, :destroy]

  def index
    videos = Video.all

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

    render(json: V1::UserSerializer.new(video).to_json)
  end

  def new
    video = Video.new
  end

  def upload
    file = params[:file]

    attachment = {
        :filename => file[:filename],
        :type => file[:type],
        :headers => file[:head],
        :tempfile => file[:tempfile]
    }

    video = Video.new

    video.file = ActionDispatch::Http::UploadedFile.new(attachment)

    video.file_path = attachment[:filename]

    video.title = params[:file]
    video.description = params[:description]
    video.confidentiality = params[:confidentiality]

    video.save!

    render(
      json: V1::VideoSerializer.new(video).to_json,
      status: 201,
      location: api_v1_video_path(video.id)
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
    params.require(:video).permit(:title, :description, :confidentiality, :file, :user_id)
  end

  def find_video
    video = Video.find(params[:id])
  end
end
