class V1::VideosController < V1::BaseController

  # Scopes
  scope :recent, -> { order('created_at DESC') }

  def index
    @videos = Video.all
  end
end
