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

Manga.create([
  { name: "Assassination Classroom", read_count: 0, total_count: 161, uri: "http://www.mangareader.net/assassination-classroom" },
  { name: "Naruto", read_count: 699, total_count: 700, uri: "http://www.mangareader.net/naruto" },
  { name: "Naruto Movie", read_count: 10, total_count: 10, uri: "http://www.mangareader.net/naruto-movie"},
])

Manga.all.each do |manga|
  manga.total_count.times do |t|
    Chapter.create(manga: manga, name: "#{manga.name} #{t + 1}", uri: "#{manga.uri}/#{t + 1}", read: manga.read_count > t)
  end
end
