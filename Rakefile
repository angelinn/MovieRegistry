namespace :db do
  desc "drops databases"
  task :drop do
    require_relative 'db/migrations/drop_users_table.rb'
    require_relative 'db/migrations/drop_movies_table.rb'
    require_relative 'db/migrations/drop_episodes_table.rb'
    require_relative 'db/migrations/drop_records_table.rb'
  end

  desc "creates databases"
  task :create do
    require_relative 'db/migrations/create_users_table.rb'
    require_relative 'db/migrations/create_movies_table.rb'
    require_relative 'db/migrations/create_episodes_table.rb'
    require_relative 'db/migrations/create_records_table.rb'
  end
end

namespace :test do
  desc 'runs tests'

  task :run do
    Dir.glob('%s/spec/*.rb' % Dir.pwd).each do |file|
      Rake::Task['test:run_single'].execute file[0..-9]
    end
  end

  task :run_single, :name do |t, arg|
    system('rspec --fail-fast --color #{arg}_spec.rb') or exit(1)
  end
end
