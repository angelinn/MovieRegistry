get '/movie' do
  movie = MovieDb::ImdbManager.get_by_id(params[:id])
  erb :'movie/movie', :locals => { :movie => movie,
                                   :series => params[:series] }
end

post '/add' do
  registry = MovieRegistry.new(cookies[:username])

  movie = registry.add_movie(params[:id], params[:seen_at],
                             (eval params[:series]), params[:season],
                             params[:episode])

  return redirect back unless movie
  erb :'movie/added', :locals => { :movie => movie }
end
