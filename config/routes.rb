Rails.application.routes.draw do

  devise_for :user, only: []

  constraints :subdomain => "api" do
    api_version(:module => "V1", :header => {:name => "Accept", :value => "application/vnd.mewpipe.com; version=1"}, :path => {:value => "v1"}, :defaults => {:format => "json"}, :default => true) do
    resources :users
    resources :videos
    match 'videos/upload', to: 'videos#upload', via: [:get]
    resource :login, only: [:create], controller: :sessions
    end
  end

end
