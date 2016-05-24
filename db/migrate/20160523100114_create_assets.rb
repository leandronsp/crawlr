class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :url
      t.references :page, index: true, foreign_key: true
      t.references :domain, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
