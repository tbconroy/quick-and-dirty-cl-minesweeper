class Square
  attr_reader :mine
  attr_accessor :number, :marked, :revealed

  def initialize(x_coordinate, y_coordinate, mine = false)
    @mine = mine
    @x_coordinate = x_coordinate
    @y_coordinate = y_coordinate
    @revealed = false
    @number = 0
    @marked = false
  end

  def reveal
    @revealed = true
  end

  def to_s
    return '?' if @marked == true
    return ' ' if @revealed == false
    return '*' if @mine == true
    return '.' if @number == 0
    return @number.to_s
  end

  def blank?
    @mine == false && @number < 1
  end
end
