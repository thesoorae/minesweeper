require_relative "tile"
require 'byebug'

class Board
  def initialize(size = 9)
    @size = size
    @num_bombs = size**2 / 7
    @grid = seed_board(size)
    set_values
  end

  def seed_board(size)
    tiles = Array.new(size**2) { Tile.new }
    @num_bombs.times { |i| tiles[i].value = :bomb }

    tiles.shuffle!

    grid = []
    size.times do |row|
      row_array = []
      size.times do |col|
        tile = tiles.pop
        tile.pos = [row, col]
        row_array << tile
      end
      grid << row_array
    end
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

  def reveal(pos)

    self[pos].reveal! unless self[pos].flagged

    if self[pos].value == 0
      tiles_to_reveal = adjacent_tiles(pos).reject do |tile|
        tile.revealed?
      end

      tiles_to_reveal.each do |tile|
        reveal(tile.pos)
      end
    end
  end

  def render
    @grid.each do |row|
      p row.map(&:to_s)
    end
  end

  def won?
    hidden_tiles = @grid.flatten.reject { |tile| tile.revealed? }
    hidden_tiles.size == @num_bombs
  end

  def reveal_all
    @grid.flatten.map do |tile|
      tile.reveal!
    end
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def valid_pos?(pos)
    row, col = pos
    row.between?(0, @size - 1) && col.between?(0, @size - 1)
  end
end
