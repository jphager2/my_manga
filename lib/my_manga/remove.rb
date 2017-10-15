# frozen_string_literal: true

module MyManga
  module CLI
    module Commands
      # See desc
      class Remove < MyManga::CLI::Command
        desc 'Remove a manga from your library'
        argument :name, required: true, desc: 'Manga name'

        def call(name:)
          return unless MyManga.remove(name)

          puts %("#{name}" removed from your library!)
        end
      end
    end
  end
end
