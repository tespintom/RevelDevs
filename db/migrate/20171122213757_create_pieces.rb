class CreatePieces < ActiveRecord::Migration[5.1]
  def change
    create_table :pieces do |t|
      t.references :game
      t.string :type
      t.integer :x
      t.integer :y
      t.string :color
      t.timestamps
    end
  end
end
