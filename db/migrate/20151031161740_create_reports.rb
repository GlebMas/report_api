class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :impressions
      t.integer :conversions
      t.float :ctr
      t.decimal :spent
      t.integer :clicks
      t.references :campaign, index: true, foreign_key: true
      t.references :creative, index: true

      t.timestamps null: false
    end
  end
end
