# frozen_string_literal: true

module MyManga
  module CLI
    module Commands
      # See desc
      class Download < MyManga::CLI::Command
        desc 'Download manga from your library'
        argument :names, desc: 'Manga names (comma separated)'
        option :all,
               type: :boolean,
               default: true,
               desc: 'Download all unread'
        option :list,
               desc: 'List of chapters to download (comma separated)'
        option :from,
               desc: 'First chapter to download (must be used with TO)'
        option :to,
               desc: 'Last chapter to download (must be used with FROM)'

        def call(names: nil, **options)
          names = manga_names(names)
          numbers = if options[:list]
                      options[:list].to_s.split(',').map(&:strip)
                    elsif options[:to]
                      (options.fetch(:from)..options.fetch(:to)).to_a
                    end

          names.each do |name|
            manga = MyManga[name]
            chapters = numbers || manga.chapters_unread_numbers
            count = chapters.length

            next unless count.positive?

            puts "Downloading #{count} Chapters from \"#{name}\""
            MyManga.download(manga, chapters)
          end

          puts '...'
          puts 'Finished Download!'
        end
      end
    end
  end
end
