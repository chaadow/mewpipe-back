Rails.application.routes.draw do

  constraints :subdomain => "api" do
    api_version(:module => "V1", :header => {:name => "Accept", :value => "application/vnd.mewpipe.com; version=1"}, :path => {:value => "v1"}, :defaults => {:format => "json"}, :default => true) do
    resources :videos
    end
  end

end
