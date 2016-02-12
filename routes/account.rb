get '/login' do
  erb :'account/login'
end

post '/login' do
  cookies[:username] = params[:username]
  redirect '/index'
end
