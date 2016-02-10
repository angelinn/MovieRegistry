namespace :db do
  desc "drops databases"
  task :drop do
    ARGV = ['down']
    require_relative 'db/migrations/create_users_table.rb'
    require_relative 'db/migrations/create_movies_table.rb'
    require_relative 'db/migrations/create_episodes_table.rb'
  end

  desc "creates databases"
  task :create do
    ARGV = ['up']
    require_relative 'db/migrations/create_users_table.rb'
    require_relative 'db/migrations/create_movies_table.rb'
    require_relative 'db/migrations/create_episodes_table.rb'
  end
end
