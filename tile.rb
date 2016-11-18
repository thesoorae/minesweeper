class Tile
  attr_accessor :value, :pos, :flagged

  def initialize
    @value = 0
    @reveal = false
    @flagged = false
  end

  def bomb?
    @value == :bomb
  end

  def reveal!
    @reveal = true
  end

  def revealed?
    @reveal
  end

  def flag
    @flagged = !@flagged
  end

  def to_s
    if @flagged
      "F"
    elsif  !@reveal
      "_"
    elsif @value.is_a?(Integer)
      @value.to_s
    else
      "*"
    end
  end
end
