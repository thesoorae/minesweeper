require_relative "tile"
require 'byebug'

class Board
  def initialize(size = 9)
    @size = size
    @grid = Array.new(size) { Array.new(size) { Tile.new } }
  end

  def seed_board
  end

  def adjacent_tiles(pos)
    # returns array of Tiles adjacent to pos
    row, col = pos
    adjacents = []

    (row - 1..row + 1).each do |row_idx|
      (col - 1..col + 1).each do |col_idx|
        new_pos = [row_idx, col_idx]
        # debugger
        if valid_pos?(new_pos) && (new_pos != pos)
          adjacents << self[new_pos]
        end
      end
    end

    adjacents
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def valid_pos?(pos)
    row , col = pos
    row.between?(0, @size - 1) && col.between?(0, @size - 1)
  end
end
