require 'pry'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }
  use Rack::Flash

  get '/' do
    erb :index
  end

  get '/songs' do
  	@songs = Song.all
  	erb :songs
  end

  get '/artists' do
  	@artists = Artist.all
  	erb :artists
  end

  get '/genres' do
  	@genres = Genre.all
  	erb :genres
  end

  get '/songs/new' do
  	erb :new_song
  end

  post '/songs' do
  	@song = Song.create(params[:song])
  	params[:genres].each do |genre|
  		@song.genres << Genre.find_by(name: genre)
  	end
  	found = Artist.find_by(name: params[:artist])
  	if !!found
  		@song.artist = found
  	else
  		@song.artist = Artist.create(name: params[:artist])
  	end
  	@song.save
  	flash[:message] = "Successfully created song."
  	redirect "/songs/#{@song.slug}"
  end

  patch '/songs' do
  	@song = Song.find_by(params[:song])
  	@song.genres = []
  	params[:genres].each do |genre|
  		@song.genres << Genre.find_by(name: genre)
  	end
  	found = Artist.find_by(name: params[:artist])
  	if !!found
  		@song.artist = found
  	else
  		@song.artist = Artist.create(name: params[:artist])
  	end
  	@song.save
  	flash[:message] = "Successfully updated song."
  	redirect "/songs/#{@song.slug}"
  end

  get '/songs/:slug' do
  	@song = Song.find_by_slug(params[:slug])
  	erb :'show_song'
  end

  get '/songs/:slug/edit' do
  	@song = Song.find_by_slug(params[:slug])
  	erb :'edit_song'
  end

  get '/artists/:slug' do
  	@artist = Artist.find_by_slug(params[:slug])
  	erb :show_artist
  end

  get '/genres/:slug' do
  	@genre = Genre.find_by_slug(params[:slug])
  	erb :show_genre
  end

end