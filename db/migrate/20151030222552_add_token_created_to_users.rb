class AddTokenCreatedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token_created, :datetime
  end
end
