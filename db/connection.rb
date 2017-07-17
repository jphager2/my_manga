module MyManga
  class DB 
    MIGRATION_PATH = File.expand_path('../migrate', __FILE__)
    CONFIG_PATH = File.expand_path('../config.yml', __FILE__)
    CONFIG = YAML.load(ERB.new(File.read(CONFIG_PATH)).result)[MyManga.env]

    def self.establish_connection
      ActiveRecord::Base.establish_connection(CONFIG)
    end 

    def self.establish_base_connection
      ActiveRecord::Base.establish_connection(
        CONFIG.merge(
          {
            "database" => "postgres",
            "schema_search_path" => "public",
          }
        )
      )
    end

    def self.connection
      ActiveRecord::Base.connection
    end

    def self.create_database
      connection.create_database(CONFIG["database"], CONFIG)
    end

    def self.drop_database
      connection.drop_database(CONFIG["database"])
    end

    def self.migrate
      ActiveRecord::Migrator.migrate(MIGRATION_PATH, nil)
    end

    def self.dump
      system("pg_dump -Fc #{CONFIG["database"]} > #{File.expand_path(__dir__)}/latest.dump")
    end
  end
end


