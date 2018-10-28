# frozen_string_literal: true

require_relative './command'
require_relative './version'
require_relative './find'
require_relative './add'
require_relative './remove'
require_relative './list'
require_relative './download'
require_relative './update'
require_relative './mark'
require_relative './env'
require_relative './m_clean_up'
require_relative './zine'

module MyManga
  module CLI
    # Registry for CLI commands
    module Commands
      extend Hanami::CLI::Registry

      # see desc
      class Version < MyManga::CLI::Command
        desc 'Print version'

        def call(*)
          puts MyManga::VERSION
        end
      end

      register 'version', Version, aliases: %w[v -v --version]
      register 'find', Find, aliases: %w[search]
      register 'add', Add
      register 'remove', Remove, aliases: %w[delete]
      register 'list', List, aliases: %w[library show]
      register 'download', Download
      register 'update', Update, aliases: %w[fetch]
      register 'mark', Mark
      register 'env', Env, aliases: %w[-e --environment]
      register 'm:clean_up', MCleanUp, aliases: %w[purge]
      register 'zine', Zine
    end
  end
end
