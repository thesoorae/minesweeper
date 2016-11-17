class Tile
  attr_accessor :value

  def initialize
    @value = 0
    @reveal = false
  end

  def reveal
    @reveal = true
  end

  def to_s
    if @value == 0
      "_"
    elsif @value.is_a?(Integer)
      @value.to_s
    else
      "*"
    end
  end
end
