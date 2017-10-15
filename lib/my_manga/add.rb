# frozen_string_literal: true

module MyManga
  module CLI
    module Commands
      # See desc
      class Add < MyManga::CLI::Command
        desc 'Add a manga to your library'
        argument :url, required: true, desc: 'Manga url'

        def call(url:)
          manga = MyManga.add(url)

          return unless manga

          puts %("#{manga.name}" added to your library!)
        end
      end
    end
  end
end
