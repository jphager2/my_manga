# frozen_string_literal: true

module MyManga
  module CLI
    module Commands
      # See desc
      class Find < MyManga::CLI::Command
        desc 'Search for a manga by name'
        argument :search_term, required: true, desc: 'Manga name'

        def call(search_term:)
          results = MyManga.find(search_term)

          puts "Manga found for \"#{search_term}\""
          puts '=' * (18 + search_term.length)

          return if results.empty?

          column_width = results.map { |r| r[:name].length }.max
          puts pad('Name', column_width) + 'Url'
          results.each do |result|
            puts pad(result[:name], column_width) + result[:uri]
          end
        end
      end
    end
  end
end
