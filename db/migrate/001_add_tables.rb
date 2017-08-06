class AddTables < ActiveRecord::Migration[4.2]
  create_table :manga do |t|
    t.string :name
    t.string :uri
    t.integer :read_count, default: 0
    t.integer :total_count, default: 0

    t.timestamps null: false
  end

  create_table :chapters do |t|
    t.string :name
    t.string :uri
    t.integer :number
    t.boolean :read, default: false
    t.integer :manga_id

    t.timestamps null: false
  end
end
