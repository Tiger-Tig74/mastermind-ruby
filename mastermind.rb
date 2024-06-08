# frozen_string_literal: true

# The Mastermind class encapsulates the logic of the Mastermind game.
# It handles the game setup, processing guesses, and checking for correctness.
class Mastermind
  COLORS = %w[R G B Y O P].freeze
  CODE_LENGTH = 4
  TURNS = 12

  def initialize
    @secret_code = Array.new(CODE_LENGTH) { COLORS.sample }
    @turns_left = TURNS
  end

  def play # rubocop:disable Metrics/MethodLength
    puts 'Welcome to Mastermind!'
    puts "Try to guess the code of #{CODE_LENGTH} colors."
    puts "Available colors: #{COLORS.join(', ')}"
    while @turns_left.positive?
      puts "\nYou have #{@turns_left} turns left."
      guess = request_guess
      feedback = provide_feedback(guess)
      puts "Feedback: #{feedback}"
      if feedback == '4 exact matches, 4 color matches'
        puts 'Congratulations! You guessed the code!'
        return
      end
      @turns_left -= 1
    end
    puts "Sorry, you've run out of turns. The secret code was #{@secret_code.join}."
  end

  def request_guess
    loop do
      print 'Enter your guess: '
      guess = gets.chomp.upcase.chars
      return guess if valid_guess?(guess)

      puts "Invalid guess. Make sure it is #{CODE_LENGTH} characters long
      and only contains the colors: #{COLORS.join(', ')}."
    end
  end

  def valid_guess?(guess)
    guess.length == CODE_LENGTH && guess.all? { |color| COLORS.include?(color) }
  end

  def provide_feedback(guess)
    exact_matches = count_exact_matches(guess)
    color_matches = count_color_matches(guess)
    "#{exact_matches} exact matches, #{color_matches} color matches"
  end

  def count_exact_matches(guess)
    (0...CODE_LENGTH).count { |i| guess[i] == @secret_code[i] }
  end

  def count_color_matches(guess)
    secret_code_copy = @secret_code.dup
    guess.each do |color|
      secret_code_copy.delete_at(secret_code_copy.index(color)) if secret_code_copy.include?(color)
    end
    CODE_LENGTH - secret_code_copy.size
  end
end

game = Mastermind.new
game.play
