# frozen_string_literal: true

require 'fileutils'

module MyManga
  module CLI
    module Commands
      # See desc
      class Zine < MyManga::CLI::Command
        desc 'Build a new zine, or manage zine manga'
        argument :names, desc: 'Manga names (comma separated)'

        option :add,
               type: :boolean,
               default: false,
               desc: 'Add manga to zine'
        option :remove,
               type: :boolean,
               default: false,
               desc: 'Remove manga from zine'
        option :recover,
               type: :boolean,
               default: true,
               desc: 'Recover failed zine'
        option :size,
               default: '10',
               desc: 'Number of chapters to include in the zine'
        option :filename,
               desc: 'Filename for the zine, (default `zine-<timestamp>-<hash of chapters included>`)'

        TMP_DIR = File.expand_path('../../tmp', __dir__)
        RECOVERY_FILE = File.expand_path('../../zine-recovery.yaml', __dir__)

        def call(names: nil, **options)
          names = manga_names(names)
          filename = options.fetch(:filename) { nil }
          size = options.fetch(:size).to_i

          if options[:add] && options[:remove]
            puts "--add and --remove are mutually exclusive"
            exit 1
          end

          if options[:recover] == false && File.exist?(RECOVERY_FILE)
            File.delete(RECOVERY_FILE)
          end

          if options[:add]
            MyManga.add_to_zine(names)
            puts %("#{names.join(', ')}" added to the zine!)
          elsif options[:remove]
            MyManga.remove_from_zine(names)
            puts %("#{names.join(', ')}" removed from the zine!)
          else
            publish(filename, size)
          end
        end

        private

        def publish(filename, size)
          Dir.mkdir(TMP_DIR) unless Dir.exist?(TMP_DIR)

          zine = zine_content(size)

          File.write(RECOVERY_FILE, YAML.dump(zine.map(&:id)))

          Chapter.transaction do
            serialized_name = []
            zine.each do |chapter|
              serialized_name << chapter.id
              MyManga.download_chapter(chapter, TMP_DIR)
              MyManga.read!(chapter.manga, [chapter.number])
            end

            serialized_name = serialized_name.join.to_i.to_s(32)
            filename ||= "zine-#{Time.now.to_i}-#{serialized_name}"

            dir = File.join(MyManga.download_dir, filename)

            cbz(dir)
          end

          FileUtils.rm_r(TMP_DIR)
          File.delete(RECOVERY_FILE)

          puts "Pushlished a new zine (#{filename}) in #{MyManga.download_dir}"
        rescue Mangdown::Error => e
          puts "Failed to publish zine: #{e.message}"
        end

        def zine_content(size)
          return new_zine_content(size) unless File.exist?(RECOVERY_FILE)

          puts 'Recovering failed publication ...'

          chapter_ids = YAML.load_file(RECOVERY_FILE)
          Chapter.where(id: chapter_ids).sort_by do |chapter|
            chapter_ids.index(chapter.id)
          end
        end

        def new_zine_content(chapter_count)
          manga = MyManga.zine
          chapters = Chapter
                     .unread
                     .where(manga_id: manga.map(&:id))
                     .order(:number)
                     .group_by(&:manga)
                     .values
                     .sort_by(&:length)
                     .reverse

          return if chapters.empty?

          zine = chapters.first.zip(*chapters.drop(1)).flatten.compact
          zine.first(chapter_count).sort_by do |chapter|
            [chapter.manga_id, chapter.number]
          end
        end

        def cbz(dir)
          pages = Dir["#{TMP_DIR}/**/*.*"]

          Dir.mkdir(dir) unless Dir.exist?(dir)

          pages.each do |page|
            filename = File.basename(page)
            FileUtils.cp(page, File.join(dir, filename))
          end

          Mangdown::CBZ.one(dir, false)

          FileUtils.rm_r(dir)
        end
      end
    end
  end
end
