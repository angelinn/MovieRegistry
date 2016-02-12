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
