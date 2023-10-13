class Board
  def initialize
    @board = Array.new(8) { Array.new(8) }
    # initial setup
  end

  # methods for: setup, moves, remove, conditions, rendering
  def display
    p @board
  end

  def legal_move?(move)
    # select piece and location to move to
  end
end

class Piece
  attr_accessor :color

  def initialize(color)
    @color = color
  end

  def legal_moves; end
end

class Knight < Piece
  def legal_moves
    # can move 2 along any axis
    # then 1 on the perpendicular axis
    # eg. [0, 0] -> [2, 1], 8 combinationsŒ
  end
end
