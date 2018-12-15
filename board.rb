require_relative './square'

class Board

  def initialize(x_size, y_size, number_of_mines)
    @x_size = x_size
    @y_size = y_size
    @number_of_squares = @x_size * @y_size
    @mine_squares = []
    @number_of_mines = number_of_mines
    @squares = []

    select_mine_squares
    create_board
    add_mine_hints
  end

  def reveal_and_check_state(x_coordinate, y_coordinate)
    reveal_surrounding(x_coordinate.to_i, y_coordinate.to_i)
    game_state
  end

  def mark(x_coordinate, y_coordinate)
    square = find_square(x_coordinate, y_coordinate)
    square.marked = true unless square.nil?
  end

  def unmark(x_coordinate, y_coordinate)
    square = find_square(x_coordinate, y_coordinate)
    square.marked = false unless square.nil?
  end

  def reveal_all
    @squares.each do |row|
      row.each do |square|
        square.revealed = true
        square.marked = false
      end
    end
  end

  def to_s
    board = '   '
    @x_size.times { |index| board << index.to_s + ' ' }
    board << "\n"

    @squares.each_with_index do |row, index|
      board << index.to_s + ' |'
      row.each { |square| board << square.to_s + '|' }
      board << "\n"
    end

    board + "\n"
  end

  private

  def game_state
    state = 'win'

    @squares.flatten.each do |square|
      if square.mine == false && square.revealed == false
        state = 'in_progress'
      end

      if square.mine == true && square.revealed == true
        state = 'loss'
        break
      end
    end

    state
  end

  def reveal_surrounding(x_coordinate, y_coordinate)
    square = find_square(x_coordinate, y_coordinate)

    return if square.nil? || square.revealed || square.marked

    square.reveal

    if square.blank?
      reveal_surrounding(x_coordinate - 1, y_coordinate)
      reveal_surrounding(x_coordinate + 1, y_coordinate)
      reveal_surrounding(x_coordinate, y_coordinate - 1)
      reveal_surrounding(x_coordinate, y_coordinate + 1)
    end
  end

  def select_mine_squares
    random = Random.new

    while @mine_squares.length < @number_of_mines
      @mine_squares << random.rand(0..@number_of_squares)
      @mine_squares.uniq
    end

    @mine_squares.sort
  end

  def create_board
    count = 0

    @y_size.times do |y_index|
      row = []
      @x_size.times do |x_index|
        mine = !!@mine_squares.index(count)

        row << Square.new(x_index, y_index, mine)

        count += 1
      end
      @squares << row
    end
  end

  def find_square(x_coordinate, y_coordinate)
    x_coordinate = x_coordinate.to_i
    y_coordinate = y_coordinate.to_i

    return nil if x_coordinate < 0 || y_coordinate < 0

    row = @squares[y_coordinate]
    row[x_coordinate] unless row.nil?
  end

  def add_mine_hints
    @squares.each_with_index do |row, y_index|
      row.each_with_index do |square, x_index|
        increment_surrounding_hints(x_index, y_index) if square.mine
      end
    end
  end

  def increment_surrounding_hints(x_coordinate, y_coordinate)
    (-1..1).each do |y_offset|
      (-1..1).each do |x_offset|
        next if y_offset == 0 && x_offset == 0

        square = find_square(x_coordinate + x_offset, y_coordinate + y_offset)
        square.number += 1 unless square.nil?
      end
    end
  end
end
