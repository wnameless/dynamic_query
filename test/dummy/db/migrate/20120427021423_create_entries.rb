class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.text :description
      t.date :deadline
      t.string :priority
      t.references :list

      t.timestamps
    end
    add_index :entries, :priority
    add_index :entries, :list_id
  end
end
