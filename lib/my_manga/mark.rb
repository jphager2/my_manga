# frozen_string_literal: true

module MyManga
  module CLI
    module Commands
      # See desc
      class Mark < MyManga::CLI::Command
        desc 'Mark manga chapters as read/unread'
        argument :flag, required: true, desc: '[read|unread]'
        argument :names, desc: 'Manga names (comma separated)'
        option :all,
               type: :boolean,
               default: true,
               desc: 'Mark all'
        option :list,
               desc: 'List of chapters to mark (comma separated)'
        option :from,
               desc: 'First chapter to mark (must be used with TO)'
        option :to,
               desc: 'Last chapter to mark (must be used with FROM)'

        def call(flag:, names: nil, **options)
          names = manga_names(names)
          if options[:list]
            numbers = options[:list].to_s.split(',').map(&:strip)
            output ||= numbers.join(', ')
          elsif options[:to]
            numbers = (options.fetch(:from)..options.fetch(:to)).to_a
            output = [numbers.first, numbers.last].join('-')
          end
          output ||= '(all)'

          names.each do |name|
            manga = MyManga[name]
            chapters = numbers || manga.chapters_numbers
            count = chapters.length

            next unless count.positive?

            mark(manga, flag, chapters)
            print %(Chapters #{output} from "#{name}" )
            puts %(Marked as #{flag.capitalize})
          end
        end

        def mark(manga, flag, chapters)
          if flag == 'read'
            MyManga.read!(manga, chapters)
          else
            MyManga.unread!(manga, chapters)
          end
        end
      end
    end
  end
end
