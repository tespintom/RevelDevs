class AlterPiecesAddIcon < ActiveRecord::Migration[5.1]
  def change
    add_column :pieces, :icon, :string
  end
end
