class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.string :address
      t.integer :port

      t.timestamps
    end
  end
end
