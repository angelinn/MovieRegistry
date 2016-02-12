require_relative '../lib/profile_manager'

get '/login' do
  erb :'account/login'
end

post '/login' do
  cookies[:username] = params[:username]
  redirect '/index'
end

get '/profile' do
  erb :'account/profile'
end

post '/profile' do
  Profile::Manager.change_name(cookies[:username], params[:new_name])
  cookies[:username] = params[:new_name]
  redirect '/index'
end
