enable :sessions

post '/login' do
  if @user = User.authenticate(params)
    session[:user_id] = @user.id
    redirect "/user/#{@user.id}"
  else
    erb :failed_login
  end
end

get '/logout' do
  session[:user_id] = nil
  redirect '/'
end

get '/profile' do 
  if session[:user_id].nil?
    redirect '/'
  else
    user = User.find(session[:user_id])
    erb :profile, :locals => { user: user }
  end
end

post '/user/create' do
  user = User.new(email: params[:email], password: params[:password])
  
  if user.valid?
    user.save!
    session[:user_id] = user.id
    redirect '/profile'
  else
    redirect '/'
  end
end
