class CreatePieces < ActiveRecord::Migration[5.1]
  def change
    create_table :pieces do |t|
      t.text :name
      t.text :starting_position
      t.text :current_position
      t.timestamps
    end
  end
end
