class Game < ApplicationRecord
    has_many :moves
    has_many :participants
    has_many :results
end
