class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.string :description
      t.string :program_link
      t.integer :number
      t.integer :subprogram
      t.string :channelmap

      t.timestamps
    end
  end
end
