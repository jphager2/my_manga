class AddZineToManga < ActiveRecord::Migration[5.2]
  add_column :manga, :zine, :boolean, null: false, default: false
end
