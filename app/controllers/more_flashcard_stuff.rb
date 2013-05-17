require_relative 'model.rb'
require 'colorize'

class Controller

  def initialize(file)
    user_interface
    create_new_deck(@view.get_file_name)
    run_game
  end

  def create_new_deck(file)
    @new_deck = Deck.new(file)
    @new_deck.shuffle!
  end

  def user_interface
    @view = View.new
    @view.welcome_prompt
    sleep 2
    
  end
  
  def user_guess
    @new_deck.guess(@view.get_guess)
  end

  def run_game
    until @new_deck.finished?
      counter = 0 
      @view.display_definition(@new_deck.next_card)
        if user_guess
          @view.correct_answer
          @new_deck.guess_correct
        else
          puts "You guessed wrong! Try again.".red
          if user_guess
            @view.correct_answer
            @new_deck.guess_correct
          else
            @view.incorrect_answer(@new_deck.card_answer) 
            @new_deck.guess_incorrect
          end
        end
      end
    guess_count
  end
  
  def guess_count
    @view.correct_and_incorrect_count(@new_deck.num_correct,@new_deck.num_wrong)
    if @new_deck.empty?
      @view.empty_wrong_answers
    else
      @view.play_again?
      again?
    end
  end
  
  def again?
    play_again = gets.chomp
    if play_again == "yes"
      @new_deck.start_over!
      @new_deck.sort!
      run_game
    else
      @view.exit_prompt
    end
  end

end

class View

  def new_card
    @new_card
  end
  
  def get_file_name
    puts "Flash card file to load (test_flash.txt) is the default"
    input =  gets.chomp
    input.empty? ? 'test_flash.txt' : input
  end

  def get_guess
    puts "Guess:"
    @guess = gets.chomp
  end

  def welcome_prompt
    puts "Welcome to Ruby Flashcards".yellow
  end

  def display_definition(card_definition)
   puts "Definition: \n#{card_definition}".blue
 end

 def correct_answer
  puts "Katie Perry now sits on your lap!".green
end

def incorrect_answer(answer)
  puts "Incorrect: Please consult with KT Perry".red
  puts "Answer: #{answer}".red
end

def correct_and_incorrect_count(correct,incorrect)
  puts "Correct: #{correct}"
  puts "Incorrect: #{incorrect}\n"
end

def empty_wrong_answers
  puts "You are the biggest winner!!"
end

def play_again?
  puts "Do you want to finish your previous mistakes?"
end

def exit_prompt
  puts "you loser"
end  
end

test = Controller.new('test_flash.txt')
