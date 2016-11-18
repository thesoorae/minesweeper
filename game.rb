require_relative "board"
require_relative "tile"
require 'byebug'
require 'yaml'

class Game

  def self.load(filename)
    saved_state = File.read(filename)
    Game.new(YAML::load(saved_state))
  end

  def initialize(board)
    @board = board
    @game_over = false
  end

  def parse_pos(string)
    string.scan(/\d/).map(&:to_i)
  end

  def save
    puts "Enter a file name"
    saved_file_name = gets.chomp

    saved_game = @board.to_yaml

    File.open(saved_file_name, 'w') do |file|
      file.write(saved_game)
    end
  end

  def play_turn
    puts "Enter a position (ex: 3, 4)"
    pos = parse_pos(gets.chomp)
    puts "Reveal (r) or Flag (f) or Save (s)?"
    act = gets.chomp.downcase
    if act == "f"
      @board[pos].flag
      @board.render
    elsif act == "s"
      save
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
