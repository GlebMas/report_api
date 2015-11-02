class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.float :media_budget
      t.integer :campaign_manager_id
    end
  end
end
