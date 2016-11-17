require_relative "tile"
require 'byebug'

class Board
  def initialize(size = 9)
    @size = size
    @grid = seed_board(size)
    set_values
  end

  def seed_board(size)
    num_bombs = size**2 / 7

    tiles = Array.new(size**2) { Tile.new }
    num_bombs.times { |i| tiles[i].value = :bomb }

    tiles.shuffle!

    grid = []
    size.times { grid << tiles.shift(size) }
    grid
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

  def set_value(pos)
    tile = self[pos]
    unless tile.bomb?
      adjacents = adjacent_tiles(pos)
      tile.value = adjacents.inject(0) do |sum, adjacent|
        adjacent.bomb? ? sum + 1 : sum
      end
    end
  end

  def set_values
    @size.times do |row|
      @size.times do |col|
        pos = [row, col]
        set_value(pos)
      end
    end
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
