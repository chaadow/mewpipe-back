# -*- encoding : utf-8 -*-
# Retrieve environmment & set Puma workers
# To use the debuger, we must have 1 worker in dev environment
environment = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || "production"

workers 2

# Threads parameterization (number of threads inside each Puma worker)
threads_count = 2
threads threads_count, threads_count


preload_app!

rackup DefaultRackup
port ENV['PORT'] || 5000

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  # ActiveRecord::Base.establish_connection
  ActiveRecord::Base.connection_pool.disconnect!
  # Valid on Rails up to 4.1 the initializer method of setting `pool` size
  ActiveSupport.on_load(:active_record) do
    config = ActiveRecord::Base.configurations[Rails.env] ||
                Rails.application.config.database_configuration[Rails.env]
    config['pool'] = ENV['MAX_THREADS'] || 5
    ActiveRecord::Base.establish_connection(config)
  end

end
