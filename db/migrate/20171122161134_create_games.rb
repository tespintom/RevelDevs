class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      # t.string :name
      # need to add new db columns as we go.  
      t.timestamps
    end
  end
end
