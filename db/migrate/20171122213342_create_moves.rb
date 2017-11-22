class CreateMoves < ActiveRecord::Migration[5.1]
  def change
    create_table :moves do |t|
      t.integer :game_id
      t.integer :piece_id
      t.integer :participant_id
      t.integer :move_type_id
      t.text :from_position
      t.text :to_position
      t.timestamps
    end
  end
end
