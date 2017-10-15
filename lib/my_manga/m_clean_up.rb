# frozen_string_literal: true

module MyManga
  module CLI
    module Commands
      # See desc
      class MCleanUp < MyManga::CLI::Command
        desc 'Remove the manga cache for M, the mangdown client'

        def call(*)
          return unless MyManga.mangdown_client_clean_up

          puts 'M cache files removed'
        end
      end
    end
  end
end
