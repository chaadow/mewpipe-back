class EnableHstore < ActiveRecord::Migration
  enable_extension 'hstore' unless extension_enabled?('hstore')
end
