get '/flashcards/?' do 
# display decks, 
  session[:user_id] = 1 #placeholder until we implement login
  erb :flashcards
end



get '/flashcards/deck/card/?' do 
  if session[:card_ids].empty?
    redirect '/flashcards/deck/start_over'
  else
    current_card = Card.find(session[:card_ids].first)
    erb :card, :locals => {:current_card => current_card}
  end
end

post '/flashcards/deck/card/?' do

  current_card = Card.find(params[:current_card_id])
  if current_card.answer == params[:guess]
    Attempt.create!(:card_id => current_card.id, :round_id => session[:round_id], :status => 1)
    session[:last_card_status] = "Correct!"
  else
    Attempt.create!(:card_id => current_card.id, :round_id => session[:round_id], :status => 2)
    session[:last_card_status] = "You Suck!"
  end
  session[:card_ids] = session[:card_ids][1..-1]
  redirect '/flashcards/deck/card'

end


get '/flashcards/deck/start_over/?' do
  correct = Attempt.find_all_by_round_id(session[:round_id]).count { |attempt| attempt.status == 1 }
  incorrect = Attempt.find_all_by_round_id(session[:round_id]).count { |attempt| attempt.status == 2 }

  session[:card_ids] =  Attempt.find_all_by_round_id( session[:round_id]).find_all { |attempt| attempt.status == 2 }.map(&:card_id)

  erb :end, :locals => {:correct => correct, :incorrect => incorrect }
end

get '/flashcards/deck/:id' do
  session[:last_card_status] = nil
  session[:deck_id] = params[:id]
  deck = Deck.find(session[:deck_id])
  deck.users << User.find(session[:user_id])
  session[:card_ids] = Deck.find(session[:deck_id]).cards.shuffle.map(&:id)
  session[:round_id] = Round.where(:user_id => session[:user_id], :deck_id => session[:deck_id]).first.id
  redirect "/flashcards/deck/card"  
end
