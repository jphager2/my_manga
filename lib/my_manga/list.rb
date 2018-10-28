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

        private

        def list(names)
          column_width = names.map(&:length).max || 10

          puts 'Manga list'
          puts '=========='
          print pad('Name', column_width)
          puts 'Zine Chapters read/total (unread)'

          names.sort.each do |name|
            manga = MyManga[name]
            read = manga.read_count
            total = manga.total_count
            unread = total - read
            zine = check_box(manga.zine?)

            print pad(name, column_width)
            puts "#{zine} #{read}/#{total} (#{unread}) #{manga.uri}"
          end
        end

        def list_detail(name)
          manga = MyManga[name]
          header = %(Manga details for "#{manga.name}")
          chapters = manga.chapters.reorder(number: :desc)
          read = manga.read_count
          total = manga.total_count
          unread = total - read
          zine = check_box(manga.zine?)

          puts header
          puts '=' * header.length
          print pad('Name', name.length)
          puts 'Zine Chapters read/total (unread)'
          puts "#{name}  #{zine} #{read}/#{total} (#{unread}) #{manga.uri}"
          puts


          puts 'Read Chapter'
          puts '------------'
          chapters.each do |chapter|
            puts "#{chapter.read? ? ' [X]' : ' [ ]'} #{chapter.name}"
          end
        end

        def check_box(bool)
          bool ? ' [X]' : ' [ ]'
        end
      end
    end
  end
end
