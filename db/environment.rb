require 'active_record'
require 'yaml'
require 'erb'

module MyManga
  def self.env
    ENV["MY_MANGA_ENV"] || "production"
  end

  def self.env=(environment)
    ENV["MY_MANGA_ENV"] = environment
  end
end

require_relative '../db/connection.rb'

MODELS_DIR = File.expand_path("../../models", __FILE__)
Dir[MODELS_DIR + '/*.rb'].each do |file|
  require file
end

MyManga::DB.establish_connection
