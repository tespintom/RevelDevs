class Move < ApplicationRecord
  belongs_to :game
  belongs_to :piece
  has_many :move_type 
end
