class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.datetime :start_visit
      t.datetime :end_visit
      t.belongs_to :user
      t.belongs_to :hotel
      t.timestamps
    end
  end
end
