require_relative 'board'

class Game
  def start
    @board = Board.new(5,5,2)
    prompt_action
  end

  def prompt_action
    puts @board
    puts 'Select Action: (r)eveal square, (m)ark square, (u)nmark square'
    action = gets.chomp

    case action.downcase[0]
    when 'r'
      prompt_reveal_square
    when 'm'
      prompt_mark_square
    when 'u'
      prompt_unmark_square
    else
      puts 'Invalid input'
      prompt_action
    end
  end

  def prompt_mark_square
    puts 'Select square to mark: (xy)'
    coordinates = gets.chomp
    x, y = coordinates[0], coordinates[1]

    @board.mark(x,y)

    prompt_action
  end

  def prompt_unmark_square
    puts 'Select square to unmark: (xy)'
    coordinates = gets.chomp
    x, y = coordinates[0], coordinates[1]

    @board.unmark(x,y)

    prompt_action
  end

  def prompt_reveal_square
    puts 'Select square to reveal: (xy)'
    coordinates = gets.chomp
    x, y = coordinates[0], coordinates[1]

    case @board.reveal_and_check_state(x, y)
    when 'win'
      game_over_prompt(true)
    when 'loss'
      game_over_prompt(false)
    else
      prompt_action
    end
  end

  def game_over_prompt(win = false)
    message = "Game over."
    message = "You've won!" if win

    @board.reveal_all
    puts @board
    puts "#{message} Play again? (y)es, (n)o"
    answer = gets.chomp

    case answer.downcase[0]
    when 'y'
      start
    when 'n'
      puts 'Goodbye'
    else
      puts 'Invalid input'
      game_over_prompt
    end
  end
end
