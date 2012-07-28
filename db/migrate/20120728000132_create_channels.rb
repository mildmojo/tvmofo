class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string  :name
      t.string  :network
      t.string  :description
      t.string  :program_link
      t.integer :frequency
      t.integer :number
      t.string  :number_human
      t.integer :program
      t.string  :channelmap
      t.integer :quality

      t.timestamps
    end

    add_index :channels, :number
    add_index :channels, [:number, :program]
  end
end
