class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :url
      t.boolean :visited, default: false
      t.references :domain, foreign_key: true

      t.timestamps null: false
    end

    add_index :pages, [:url, :domain_id], unique: true
  end
end
