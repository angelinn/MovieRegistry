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
  rec = Records::Manager.get(params[:title], params[:season], params[:episode])

  redirect '/edit' unless rec

  erb :'movie/edit', :locals => { :rec => rec, :type => params[:type] }
end

post '/edit' do
  rec = Records::Manager.edit(params[:title],  params[:seen_at],
                              params[:season], params[:episode])

  entry = params[:type] || 'movie'
  erb :'movie/edit', :locals => { :rec => nil, :type => entry }
end

get '/seen' do
  entry = params[:type] || 'movie'
  erb :'movie/seen', :locals => { :type => entry }
end

post '/seen' do
  rec = Records::Manager.get(params[:title], params[:season], params[:episode])

  unless rec
    message = 'You have not seen this one!'
    return erb :result, :locals => { :message => message }
  end

  message = "You have seen #{rec.movie.title} on #{rec.seen_at}"
  erb :result, :locals => { :message => message }
end

