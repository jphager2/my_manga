# frozen_string_literal: true

module MyManga
  module CLI
    module Commands
      # See desc
      class Update < MyManga::CLI::Command
        desc 'Update manga from your library'
        argument :names, desc: 'Manga names (comma separated)'

        def call(names: nil, **options)
          names = manga_names(names)

          puts 'Fetching Manga'
          puts '...'

          names.each do |name|
            manga = MyManga[name]
            old_total = manga.total_count
            MyManga.update(manga)
            new_total = MyManga[name].total_count
            updated = new_total - old_total

            next if updated.zero?

            puts "Updated \"#{name}\": #{updated} new Chapters."
          end
        end
      end
    end
  end
end
