# frozen_string_literal: true

module MyManga
  module CLI
    module Commands
      # See desc
      class Env < MyManga::CLI::Command
        desc 'Print the current environment'

        def call(*)
          puts MyManga.env
        end
      end
    end
  end
end
