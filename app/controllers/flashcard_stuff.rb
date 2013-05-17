require 'csv'
require 'pry'


class Card
  attr_reader :answer, :definition, :attempts
  
  def initialize(answer, definition, attempts = 0)
    @answer = answer
    @definition = definition
    @attempts = attempts
  end

  def to_s
    "#{definition}: #{answer}"
  end

  def correct?(input)
    input == answer
  end

  def attempted!
    @attempts += 1
  end

end

class Deck

  attr_reader :false_deck, :true_deck, :working_deck
  def initialize(file_name)
    @false_deck = []
    @true_deck = []
    @working_deck = []
    load(file_name)
  end

  def load(file_name)
    all_rows = []
    File.open(file_name).each_line do |line|
      all_rows << line
    end
    all_rows.each_slice(3) do |card|
      @working_deck << Card.new(card[1].chomp, card[0].chomp)
    end
  end

  def shuffle!
    @working_deck.shuffle!
  end

  def sort!
    @working_deck.shuffle!.sort_by { |card| card.attempts }.reverse
  end

  def guess(guess)
    @working_deck[0].attempted!
    @working_deck[0].correct?(guess)
  end

  def guess_correct
    @true_deck << @working_deck.shift
  end
  
  def guess_incorrect
    @false_deck << @working_deck.shift
  end


  def finished?
    @working_deck.empty?
  end

  def empty?
    @false_deck.empty? && @working_deck.empty?
  end

  def start_over!
    @working_deck << @false_deck
    @false_deck = []
    @working_deck.flatten!
  end

  def next_card
    @working_deck[0].definition
  end

  def card_answer
    @working_deck[0].answer
  end

  def num_correct
    @true_deck.length
  end

  def num_wrong
    @false_deck.length
  end

end

