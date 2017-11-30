class AlterPiecesAddXAndY < ActiveRecord::Migration[5.1]
  def change
    add_column :pieces, :x_coord, :integer
    add_column :pieces, :y_coord, :integer 
  end
end
