class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone_number, null: false
      t.belongs_to :group
      t.belongs_to :trip
      t.references :home_place
      t.references :work_place
      t.timestamps
    end
  end
end
