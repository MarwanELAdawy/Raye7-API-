class CreateGuests < ActiveRecord::Migration[5.1]
  def change
    create_table :guests do |t|
      t.belongs_to :user
      t.belongs_to :trip
      t.timestamps
    end
  end
end
