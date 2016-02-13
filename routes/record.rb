require_relative '../lib/record_manager'

get '/edit' do
  entry = params[:type] || 'movie'
  erb :'movie/edit', :locals => { :rec => nil, :type => entry }
end

post '/browse' do
  arg = [cookies[:username], params[:title], params[:season], params[:episode]]
  rec = Records::Manager.get(*arg)

  return erb :result, :locals => { :message => 'Incorrect data!' } unless rec
  erb :'movie/edit', :locals => { :rec => rec, :type => params[:type] }
end

post '/edit' do
  arg = [cookies[:username], params[:title], params[:seen_at],
          params[:season],params[:episode]]

  rec = Records::Manager.edit(*arg)
  erb :result, :locals => { :message => 'Successfully edited!' }
end

get '/seen' do
  entry = params[:type] || 'movie'
  erb :'movie/seen', :locals => { :type => entry }
end

post '/seen' do
  arg = [cookies[:username], params[:title], params[:season], params[:episode]]
  rec = Records::Manager.get(*arg)

  error = 'You have not seen this one!'
  message = "You have seen #{rec.movie.title} on #{rec.seen_at}" rescue nil
  erb :result, :locals => { :message => rec ? message : error }
end

get '/last' do
  erb :'movie/last'
end

post '/last' do
  arg = [cookies[:username], params[:title]]
  episode = Records::Manager.get_last_episode(*arg)

  if episode
    message = "The last episode of #{params[:title]}, you have seen is \
               Season: #{episode.season}, Episode: #{episode.episode}."
  end

  error = 'You have not seen any episodes of this TV Show.'
  erb :result, :locals => { :message => episode ? message : error}
end
