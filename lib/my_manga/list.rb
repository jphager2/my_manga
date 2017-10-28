# frozen_string_literal: true

module MyManga
  module CLI
    module Commands
      # See desc
      class List < MyManga::CLI::Command
        desc 'View your manga list'
        argument :names, desc: 'Manga names (comma separated)'

        def call(names: nil)
          names = manga_names(names)
          names.one? ? list_detail(names.first) : list(names)
        end

        def list(names)
          column_width = names.map(&:length).max || 10

          puts 'Manga list'
          puts '=========='
          print pad('Name', column_width)
          puts 'Chapters read/total (unread)'

          names.sort.each do |name|
            manga = MyManga[name]
            read = manga.read_count
            total = manga.total_count
            unread = total - read

            print pad(name, column_width)
            puts "#{read}/#{total} (#{unread}) #{manga.uri}"
          end
        end

        def list_detail(name)
          manga = MyManga[name]
          header = %(Manga details for "#{manga.name}")
          chapters = manga.chapters_read
          read = manga.read_count
          total = manga.total_count
          unread = total - read

          puts header
          puts '=' * header.length
          print pad('Name', name.length)
          puts 'Chapters read/total (unread)'
          puts "#{name}  #{read}/#{total} (#{unread}) #{manga.uri}"
          puts
          puts 'Chapters Read'
          puts '-------------'
          chapters[0..2].each do |chapter|
            puts chapter.name
          end
          puts '...' if chapters.length > 4
          puts chapters[-1].name if chapters.length > 3
        end
      end
    end
  end
end
