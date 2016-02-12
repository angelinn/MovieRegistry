get '/login' do
  erb :login
end

post '/login' do
  cookies[:username] = params[:username]
  redirect '/index'
end
