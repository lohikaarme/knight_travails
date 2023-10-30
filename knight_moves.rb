class Board
  attr_accessor :board
  def initialize
    @board = Array.new(8) { Array.new(8) }
    # initial setup
  end

  # methods for: setup, moves, remove, conditions, rendering
  def display
    p @board
  end

  def legal_move?(bgn_move, end_move)
    # is the position on the board
    # can the piece mechanically move to the new position
    # does this put self in check
    legal = false


    legal
  end

  def move(piece, position)
    #
  end
end

class Piece
  attr_accessor :color

  def initialize(color)
    @color = color
  end

  def legal_move
  return false unless (0..7).include?(end_move[0]) && (0..7).include?(end_move[1])
  end
end

class Knight < Piece
  attr_accessor :legal_move

  # Method to confirm if a move is legal
  # @param value [Array] starting position
  # @param value [Array] ending position
  # @return [Boolean, nil] True if legal, False if illegal, nil if improper params
  # eg. [0, 0] -> [2, 1], 8 combinationsŒ
  def legal_move?(bgn_move, end_move)
    return nil unless bgn_move.is_a?(Array) && bgn_move.length == 2
    return nil unless end_move.is_a?(Array) && end_move.length == 2
    return false if end_move[0] < 0 || end_move[1] < 0

    legal = true
    x_axis = (end_move[0] - bgn_move[0]).abs
    y_axis = (end_move[1] - bgn_move[1]).abs

    legal = false unless x_axis == 1 && y_axis == 2 || x_axis == 2 && y_axis == 1
    legal
  end

  # Method to list all legal moves
  # @param value [Array] starting position
  # @return [Array, nil] Array of legal moves, or nil in improper param
  def legal_moves(bgn_move)
    return nil unless bgn_move.is_a?(Array) && bgn_move.length == 2

    moves = []
    move0 = []; move0[0] = bgn_move[0] + 1; move0[1] = bgn_move[1] + 2
    move1 = []; move1[0] = bgn_move[0] + 2; move1[1] = bgn_move[1] + 1
    move2 = []; move2[0] = bgn_move[0] + 2; move2[1] = bgn_move[1] - 1
    move3 = []; move3[0] = bgn_move[0] + 1; move3[1] = bgn_move[1] - 2
    move4 = []; move4[0] = bgn_move[0] - 1; move4[1] = bgn_move[1] - 2
    move5 = []; move5[0] = bgn_move[0] - 2; move5[1] = bgn_move[1] - 1
    move6 = []; move6[0] = bgn_move[0] - 2; move6[1] = bgn_move[1] + 1
    move7 = []; move7[0] = bgn_move[0] - 1; move7[1] = bgn_move[1] + 2

    moves << move0 if legal_move?(bgn_move, move0)
    moves << move1 if legal_move?(bgn_move, move1)
    moves << move2 if legal_move?(bgn_move, move2)
    moves << move3 if legal_move?(bgn_move, move3)
    moves << move4 if legal_move?(bgn_move, move4)
    moves << move5 if legal_move?(bgn_move, move5)
    moves << move6 if legal_move?(bgn_move, move6)
    moves << move7 if legal_move?(bgn_move, move7)

    return nil if moves.empty?

    moves
  end

end

# class to build nodes for MoveTree that can have n branches
class MoveNode
  attr_accessor :branches

  def initialize(piece, branches = [])
    @piece = piece
    @branches = branches
  end
end

# class to build tree to examine all possible legal moves for a piece
class MoveTree
  attr_accessor :root, :moves

def initialize(piece, bgn_move)
  # @moves = []
  # (0..7).each do |i|
  #   (0..7).each do |j|
  #       @moves << [i, j]
  #   end
  # end
  @moves = piece.legal_moves(bgn_move)
  @root = build_tree(piece, bgn_move)
end

  def build_tree(piece, bgn_move)
    return nil if piece.nil?

    root = MoveNode.new(piece, [])
    moves.each do |end_move|
      # add level order logic, want to build out breadth first.
      # will need to add all legal moves prior to moving on to next level

      # cycle through all combination, for the true values, create a new branch
      next unless piece.legal_move?(bgn_move, end_move)

      # search through tree for any instance of the same position

      # add new branch
      root.branches << build_tree(piece, end_move)
    end

    # build tree with n children as this will change depending on if the move is legal
  end
end

k1 = Knight.new('black')
p k1.legal_move?([0,0],[1,2])
p k1.legal_move?([0,0],[1,3])
p k1.legal_moves([0,0])
p knight_travalis = MoveTree.new(k1, [0,0])
p
1 + 1
