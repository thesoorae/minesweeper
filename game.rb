require_relative "board"
require_relative "tile"
require 'byebug'

class Game

  def initialize(board)
    @board = board
    @game_over = false
  end

  def parse_pos(string)
    string.scan(/\d/).map(&:to_i)
  end

  def play_turn
    puts "Enter a position (ex: 3, 4)"
    pos = parse_pos(gets.chomp)
    puts "Reveal (r) or Flag (f)?"
    act = gets.chomp.downcase
    if act == "f"
      @board[pos].flag
      @board.render
    else
      if !@board[pos].flagged && @board[pos].bomb?
        @board.reveal_all
        @board.render
        puts "You loooose"
        @game_over = true
      else
        @board.reveal(pos)
        @board.render
      end
    end
  end


  def play
    @board.render
    play_turn until @game_over || won?
    puts "You win!" if won?
  end

  def won?
    @board.won?
  end
end
