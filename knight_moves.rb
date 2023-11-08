# frozen_string_literal: true

# Board class for creating a chess board
class Board
  attr_accessor :board

  # Initialize the chess board on 8x8 array
  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  # Display the current state of the chess board
  def display
    p @board
  end

  # Check if move is legal based on starting and end positions
  def legal_move?(bgn_move, end_move); end

  # Move piece to new position on the board
  def move(piece, position); end
end

# Piece class for inheriting common piece characteristics
class Piece
  attr_accessor :color

  # Initialize the color of a piece
  def initialize(color)
    @color = color
  end

  # Check if a move legally falls on the given chess board area
  def legal_move
    false unless (0..7).include?(end_move[0]) && (0..7).include?(end_move[1])
  end
end

# Knight class for defining specific functionality for the knight piece
# This class inherits from the Piece class and overrides the legal_move? and legal_moves methods
# to implement the unique movement rules of the knight.
class Knight < Piece
  attr_accessor :legal_move

  # Confirm if a move is legal for a knight
  # @param value [Array] starting position
  # @param value [Array] ending position
  # @return [Boolean, nil] True if legal, False if illegal, nil if improper params
  def legal_move?(bgn_move, end_move)
    return nil unless bgn_move.is_a?(Array) && bgn_move.length == 2
    return nil unless end_move.is_a?(Array) && end_move.length == 2
    return false if end_move[0].negative? || end_move[1].negative?

    legal = true

    # Calculate the absolute cartesian movement of the piece
    # between ending and beginning moves
    x_axis = (end_move[0] - bgn_move[0]).abs
    y_axis = (end_move[1] - bgn_move[1]).abs

    # Confirms if piece moved the legal amount of spaces
    # For a Knight, that is 1 position in an axis, and 2 positions on the other axis
    legal = false unless x_axis == 1 && y_axis == 2 || x_axis == 2 && y_axis == 1
    legal
  end

  # List all legal moves for the knight from a given starting position
  # @param bgn_move [Array] starting position
  # @return [Array, nil] Array of legal moves, or nil in improper param
  def legal_moves(bgn_move)
    return nil unless bgn_move.is_a?(Array) && bgn_move.length == 2

    moves = []
    # Calculate all possible moves for a knight
    # and check if they are legal
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
  attr_accessor :branches, :position

  # Initialize a node with piece and position
  # optionally set n child nodes as branches
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

  # Initialize the MoveTree with a piece and a starting position on the board
  # @param piece [Object] The chess piece whose moves will be examined
  # @param position [Array] The starting position on the chess board
  def initialize(piece, position)
    @position = position
    @all_moves = (0..7).to_a.product((0..7).to_a)
    @root = build_tree(piece, position)
  end

  # Build a binary search tree to represent all possible moves for a given piece
  # from a specific starting position, using a breadth-first approach
  # @param piece [Object] The chess piece move set to examine
  # @param position [Array] The starting position on the board
  # @param created_nodes [Array] An array used to store nodes as they are created
  # @return [Object, nil] Returns a binary search tree representing all possible moves
  # for the given piece from the starting position, or nill if the piece or all_moves
  # is not defined
  def build_tree(piece, position, created_nodes = [])
    return nil unless piece && @all_moves

    # Get all legal moves for the piece from the starting position
    legal_moves = piece.legal_moves(position)
    return nil if legal_moves.nil?

    # Filter out moves that are no longer available on the board
    moves = legal_moves.select { |move| @all_moves.include?(move) }
    @all_moves = @all_moves.delete_if { |move| moves.include?(move) }

    # Create a new root node for the tree
    root = MoveNode.new(piece, position)

    # For each remaining move, create a new node and add it to the tree
    moves.each do |move|
      node = MoveNode.new(piece, move)
      root.branches << node
      created_nodes << node
    end

    # Continue building the tree until all nodes have been added
    until created_nodes.empty?
      node = created_nodes.shift
      legal_moves = piece.legal_moves(node.position)
      moves = legal_moves.select { |move| @all_moves.include?(move) }
      @all_moves = @all_moves.delete_if { |move| moves.include?(move) }

      moves.each do |move|
        child_node = MoveNode.new(piece, move)
        node.branches << child_node
        created_nodes << child_node
      end
    end
    root
  end

  # Find the shortest path to a given position within the tree
  # @param [Array] The ending position of the piece
  # @param path [Array] The current path being explored
  # @param node [Object] The current node being examined
  # @param start [Boolean] Indicates whether this is the start of the search
  # @returns [Array, nil] Returns the shortest path to the given position,
  # or nil if the position is not found
  def find_path(position, path = [], node = root, start: true)
    return nil if node.nil?

    if position == node.position
      path << node.position
      return path
    end

    node.branches.each do |branch|
      result = find_path(position, path, branch, start: false)
      if result
        path << node.position
        return path
      end
    end
    p nodes if start && !path.empty?
    nil
  end

  # Find the shortest path a knight can take between two positions on a chess board
  # This method is called on the MoveTree class
  # @param bgn_position [Array] The initial position of the knight
  # @param end_position [Array] The final position of the knight
  # @returns [Text] Prints step by step path from initial to ending position and the number of moves to get there
  def self.knight_moves(bgn_position, end_position)
    piece = Knight.new('black')
    knight_travalis = MoveTree.new(piece, bgn_position)
    path = knight_travalis.find_path(end_position)
    path = path.reverse

    puts "You made it in #{(path.count) - 1} moves! Heres your path:"
    path.each do |position|
      puts "#{position}"
    end
  end
end

MoveTree.knight_moves([3, 3], [4, 3])
