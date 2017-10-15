module MyManga
  module CLI
    # Base class for CLI commands
    class Command < Hanami::CLI::Command
      def manga_names(input)
        all = MyManga.names
        names = Array(input.to_s.split(',')).map(&:strip)

        names.empty? ? all : all & names
      end

      def pad(string, width, with: ' ')
        string.ljust(width + 2, with)
      end
    end
  end
end
