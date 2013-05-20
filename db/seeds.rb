

def load(file_name)
  all_rows = []
  File.open(file_name).each_line do |line|
    all_rows << line
  end
  test_deck = Deck.create!(name: 'Test2')
  all_rows.each_slice(3) do |card|
    test_deck.cards << Card.create!(question: card[0].chomp, answer: card[1].chomp)
  end

end

load("#{APP_ROOT}/db/flashcard_sample.txt")


# User.create(:user_name => "jack", :email => "jack@jack.com", :password => "1234figstreet")
