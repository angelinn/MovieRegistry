require_relative '../lib/record_manager'

get '/movie' do
  movie = MovieDb::ImdbManager.get_by_id(params[:id])
  erb :'movie/movie', :locals => { :movie => movie,
                                   :series => params[:series] }
end

post '/add' do
  registry = Movies::Registry.new(cookies[:username])

  movie = registry.add_movie(params[:id], params[:seen_at],
                             (eval params[:series]), params[:season],
                             params[:episode])

  return redirect back unless movie
  erb :'movie/added', :locals => { :movie => movie }
end

get '/edit' do
  entry = params[:type] || 'movie'
  erb :'movie/edit', :locals => { :rec => nil, :type => entry }
end

post '/browse' do
  rec = Records::Manager.get(cookies[:username], params[:title], params[:season], params[:episode])

  redirect '/edit' unless rec
  erb :'movie/edit', :locals => { :rec => rec, :type => params[:type] }
end

post '/edit' do
  rec = Records::Manager.edit(cookies[:username], params[:title],  params[:seen_at],
                              params[:season], params[:episode])

  entry = params[:type] || 'movie'
  erb :'movie/edit', :locals => { :rec => nil, :type => entry }
end

get '/seen' do
  entry = params[:type] || 'movie'
  erb :'movie/seen', :locals => { :type => entry }
end

post '/seen' do
  rec = Records::Manager.get(cookies[:username], params[:title], params[:season], params[:episode])

  error = 'You have not seen this one!'
  message = "You have seen #{rec.movie.title} on #{rec.seen_at}" rescue nil
  erb :result, :locals => { :message => rec ? message : error }
end

get '/last' do
  erb :'movie/last'
end

post '/last' do
  episode = Records::Manager.get_last_episode(cookies[:username], params[:title])
  message = "The last episode of #{params[:title]}, you have seen is \
             Season: #{episode.season}, Episode: #{episode.episode}." rescue nil

  error = 'You have not seen any episodes of this TV Show.'
  erb :result, :locals => { :message => episode ? message : error}
end
