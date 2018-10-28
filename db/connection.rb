module MyManga
  module DB
    MIGRATION_PATH = File.expand_path('../migrate', __FILE__)
    CONFIG_PATH = File.expand_path('../config.yml', __FILE__)
    CONFIG = YAML.load(ERB.new(File.read(CONFIG_PATH)).result)[MyManga.env]

    module_function

    def establish_connection
      ActiveRecord::Base.establish_connection(CONFIG)
    end

    def establish_base_connection
      ActiveRecord::Base.establish_connection(
        CONFIG.merge(
          {
            "database" => "postgres",
            "schema_search_path" => "public",
          }
        )
      )
    end

    def connection
      ActiveRecord::Base.connection
    end

    def create_database
      connection.create_database(CONFIG["database"], CONFIG)
    end

    def drop_database
      connection.drop_database(CONFIG["database"])
    end

    def migrate
      ActiveRecord::MigrationContext.new(MIGRATION_PATH).migrate
    end

    def restore
      system("pg_restore --verbose --clean --no-acl --no-owner -d #{CONFIG["database"]} #{File.expand_path(__dir__)}/latest.dump")
    end

    def dump
      system("pg_dump -Fc #{CONFIG["database"]} > #{File.expand_path(__dir__)}/latest.dump")
    end
  end
end
