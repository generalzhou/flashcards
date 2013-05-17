class Card < ActiveRecord::Base

  belongs_to :deck

  def check_guess(guess)
    self.question == guess
  end

end
