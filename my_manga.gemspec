# frozen_string_literal: true

require_relative 'lib/my_manga/version'

files = Dir.glob(Dir.pwd + '/**/*.{rb,yml}')
files.collect! { |file| file.sub(Dir.pwd + '/', '') }
files.push('LICENSE', 'README.md')

Gem::Specification.new do |s|
  s.name = 'my_manga'
  s.version = MyManga::VERSION
  s.date = Time.now.strftime('%Y-%m-%d')
  s.homepage = 'https://github.com/jphager2/my_manga'
  s.summary = 'Manage Manga Downloads'
  s.description = 'Manage Manga Downloads'
  s.authors = ['jphager2']
  s.email = 'jphager2@gmail.com'
  s.files = files
  s.executables = ['my_manga']
  s.license = 'MIT'

  s.add_runtime_dependency 'activerecord', '~> 5.0'
  s.add_runtime_dependency 'hanami-cli', '~> 0.1.0'
  s.add_runtime_dependency 'mangdown', '~> 0.17.5'
  s.add_runtime_dependency 'pg', '~> 0.21'

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'minitest'
end

