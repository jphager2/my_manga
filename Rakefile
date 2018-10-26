require 'rake'

namespace :db do
  require_relative 'db/environment'

  task :create do
    MyManga::DB.establish_base_connection
    MyManga::DB.create_database
  end

  task :drop do
    MyManga::DB.establish_base_connection
    MyManga::DB.drop_database
  end

  task :migrate do
    MyManga::DB.establish_connection
    MyManga::DB.migrate
  end

  task :restore do
    MyManga::DB.restore
  end

  task :dump do
    MyManga::DB.dump
  end
end
