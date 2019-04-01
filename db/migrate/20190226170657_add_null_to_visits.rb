class AddNullToVisits < ActiveRecord::Migration[5.2]
  def change
    change_column :visits, :user_id, :integer, :null => true
  end
end
