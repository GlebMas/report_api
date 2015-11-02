class CreateCreatives < ActiveRecord::Migration
  def change
    create_table :creatives do |t|
      t.string :name
      t.integer :creative_number, index: true
      t.references :campaign, index: true, foreign_key: true
    end
  end
end
