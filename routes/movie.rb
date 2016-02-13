require_relative '../lib/record_manager'

get '/movie' do
  movie = MovieDb::ImdbManager.get_by_id(params[:id])
  erb :'movie/movie', :locals => { :movie => movie,
                                   :series => params[:series] }
end

post '/add' do
  registry = Movies::Registry.new(cookies[:username])
  series = eval(params[:series])

  args = [params[:id], params[:seen_at], series,
          params[:season], params[:episode]]

  movie = registry.add_movie(*args)

  return erb :result, :locals => { :message => 'Wrong data!' }
  erb :'movie/added', :locals => { :movie => movie }
end

