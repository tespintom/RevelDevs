class Game < ApplicationRecord
  has_many :moves
  has_many :participants
  has_many :results

  scope :available, -> {where("total_players = 1")}
end
