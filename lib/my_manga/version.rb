# frozen_string_literal: true

module MyManga
  VERSION = '1.0.0'

  module CLI
    module Commands
      # See desc
      class Version < MyManga::CLI::Command
        desc 'Print version'

        def call(*)
          puts MyManga::VERSION
        end
      end
    end
  end
end
