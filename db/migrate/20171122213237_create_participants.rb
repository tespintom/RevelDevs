class CreateParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table :participants do |t|
      t.integer :player_id
      t.integer :game_id
      t.integer :score
      t.timestamps
    end
  end
end
