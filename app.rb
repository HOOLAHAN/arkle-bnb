$LOAD_PATH << 'lib'
require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require './lib/listing'
require './lib/listing_repository'
require './lib/dates_list_repository'
require './lib/requests_repository'
require 'user_repository'

DatabaseConnection.connect('bnb_test')

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  enable :sessions

  get '/' do
    if session[:name].nil?
      return erb(:welcome)
    else
      return erb(:welcomeloggedin)
    end
  end

  get '/welcome' do
    return erb(:welcome)
  end

  get '/signup' do
    return erb(:signup)
  end

  get '/login' do
    return erb(:login)
  end

  post '/signup' do
    new_user = User.new
    new_user.name = params[:name]
    new_user.email = params[:email]
    new_user.password = params[:password]
    @user = new_user.name
    UserRepository.new.create(new_user)
    session[:name] = new_user.name
    session[:email] = new_user.email
    session[:user_id] = new_user.id
    @user = session[:name]
    return erb(:menu_page)
  end

  post '/login' do
    new_user = UserRepository.new.find_user_by_email(params[:email])
    if params[:password] == new_user.password
      session[:name] = new_user.name
      session[:email] = new_user.email
      session[:user_id] = new_user.id
      @user = session[:name]
      return erb(:menu_page)
    else
      status 400
      return 'password wrong'
    end
  end

  get '/logout' do
    session.clear
    redirect('/')
  end

  get '/menu_page' do
    return erb(:menu_page)
  end

  get '/create_listing' do
    return erb(:create_listing)
  end

  post '/listings' do
    listing = ListingRepository.new
    @new_listing = Listing.new

    @new_listing.user_id = session[:user_id]

    @new_listing.name = params[:name]
    @new_listing.description = params[:description]
    @new_listing.night_price = params[:night_price]

    new_id = listing.create(@new_listing)

    dateslist = DatesListRepository.new.add_dates(new_id, params[:start_date], params[:end_date])

    return erb(:create_listing)
  end

  get '/listings' do
    repo = ListingRepository.new
    @listings = repo.all

    return erb(:listings)
  end

  post '/book_a_night/:listing_id' do
    repo = DatesListRepository.new
    listing_id = params[:listing_id]
    dates_list = repo.find_by_listing_as_objects(listing_id)

    dates_list.each do |date_list|
      if params[:date] == date_list.date
        @date_list_id = date_list.id
        break
      end
    end
    if @date_list_id.nil?
      return 'error'
    else
      # CREATE THE REQUEST
      request_repo = RequestsRepository.new
      request = Request.new
      request.user_id = session[:user_id]
      request.date_list_id = @date_list_id
      request_repo.create(request)

      return erb(:booking_requested)
    end
  end

  get '/listings/:listing_id' do
    repo = ListingRepository.new
    @listing = repo.find(params[:listing_id])

    return erb(:listing)
  end
end
