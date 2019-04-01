class CreateHotels < ActiveRecord::Migration[5.2]
  def change
    create_table :hotels do |t|
      t.string :address
      t.string :image_url
      t.integer :price
      t.string :name
      t.string :city
      t.timestamps
    end
  end
end
