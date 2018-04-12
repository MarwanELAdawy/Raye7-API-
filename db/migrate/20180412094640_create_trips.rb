class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips do |t|
      t.string :departure_time,   null: false
      t.integer :seats,           null: false
      t.references :driver
      t.belongs_to :group
      t.references :source
      t.references :destination
      t.timestamps
    end
  end
end
