Rails.application.routes.draw do

  devise_for :user, only: []

    api_version(:module => "V1", :header => {:name => "Accept", :value => "application/vnd.mewpipe.com; version=1"}, :path => {:value => "v1"}, :defaults => {:format => "json"}, :default => true) do
    resources :users
    resources :videos do
      member do
        put :increment_view
      end
    end
    match 'videos/upload', to: 'videos#upload', via: [:post]
    resource :login, only: [:create], controller: :sessions
    end

end
