require 'minitest/autorun'
require 'minitest/pride'

ENV["MY_MANGA_ENV"] = "test"
ENV["MY_MANGA_DOWNLOAD_DIR"] = File.expand_path("../downloads", __FILE__)

require_relative "../db/environment"

MyManga::DB.establish_base_connection
MyManga::DB.drop_database
MyManga::DB.create_database

MyManga::DB.establish_connection
MyManga::DB.migrate
