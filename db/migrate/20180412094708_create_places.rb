class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|
      t.string :name, null: false, unique: true
      t.string :longitude, null: false
      t.string :latitude, null: false
      t.timestamps
    end
  end
end
