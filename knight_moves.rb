# Board class for creating a chess board
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

# Piece class for inheriting common piece characteristics
class Piece
  attr_accessor :color

  def initialize(color)
    @color = color
  end

  def legal_move
  return false unless (0..7).include?(end_move[0]) && (0..7).include?(end_move[1])
  end
end

# Knight class for defining specific functionality for the knight piece
# This class inherits from the Piece class and overrides the legal_move? and legal_moves methods
# to implement the unique movement rules of the knight.
class Knight < Piece
  attr_accessor :legal_move

  # Method to confirm if a move is legal
  # @param value [Array] starting position
  # @param value [Array] ending position
  # @return [Boolean, nil] True if legal, False if illegal, nil if improper params
  def legal_move?(bgn_move, end_move)
    return nil unless bgn_move.is_a?(Array) && bgn_move.length == 2
    return nil unless end_move.is_a?(Array) && end_move.length == 2
    return false if end_move[0] < 0 || end_move[1] < 0

    legal = true
    # x and y axis determine the absolute cartesian movement of the piece
    # between ending and beginning moves. Giving total movement along each axis.
    x_axis = (end_move[0] - bgn_move[0]).abs
    y_axis = (end_move[1] - bgn_move[1]).abs

    # Confirms if piece moved the legal amount of spaces
    # For a Knight, that is 1 position in one axis, and 2 positions on the other axis
    legal = false unless x_axis == 1 && y_axis == 2 || x_axis == 2 && y_axis == 1
    legal
  end

  # Method to list all legal moves for the knight from a given starting position
  # @param value bgn_move [Array] starting position
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

    moves.sort
  end
end

# class to build nodes for MoveTree that can have n branches
class MoveNode
  attr_accessor :branches

  def initialize(piece, position, branches = [])
    @piece = piece
    @position = position
    @branches = branches
  end
end

# Tree class to build tree to examine all possible legal moves for a piece
# Method to build tree
class MoveTree
  attr_accessor :root, :position, :all_moves

  def initialize(piece, position)
    @position = position
    @all_moves = (0..7).to_a.product((0..7).to_a)
    @root = build_tree(piece, position)
  end

  # Method to build binary search tree from given piece and position
  def build_tree(piece, position)
    return nil if piece.nil?

    legal_moves = piece.legal_moves(position)

    moves = legal_moves.select { |move| @all_moves.include?(move)}
    @all_moves = @all_moves.delete_if { |move| moves.include?(move)}

    root = MoveNode.new(piece, position)

    moves.each do |move|
      node = build_tree(piece, move)
      root.branches << node unless node.nil?
    end

    root
  end
end

k1 = Knight.new('black')
p k1.legal_move?([0,0],[1,2])
p k1.legal_move?([0,0],[1,3])
p k1.legal_moves([0,0])
p a = k1.legal_moves([3,3])
p 1+1
p knight_travalis = MoveTree.new(k1, [3,3])
p 1 + 1
