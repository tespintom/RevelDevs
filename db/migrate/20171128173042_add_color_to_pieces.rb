class AddColorToPieces < ActiveRecord::Migration[5.1]
  def change
    add_column :piece, :color, :string
  end
end
