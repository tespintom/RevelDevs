class AddDefaultValueToPieces < ActiveRecord::Migration[5.1]
  def change
    change_column :pieces, :captured, :boolean, default: false
  end
end
