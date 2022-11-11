$LOAD_PATH << 'lib'
require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require './lib/listing'
require './lib/listing_repository'
require './lib/dates_list_repository'
require './lib/requests_repository'
require './lib/user_repository'
require './lib/text'

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
    text_content = 'Signup Successful!', "Thank you, #{new_user.name} for signing up to ArkleBnB"
    new_text = Text.new
    new_text.send_text(text_content)
    # send_email('arklebnb@gmail.com', 'bezel@mailinator.com', 'testing', 'content')
    # send_email(new_user.email, 'Signup Successful!', "Thank you, #{new_user.name} for signing up to ArkleBnB")

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
    # send_email(session[:email], 'Listing Successful!', "Thank you, #{session[:name]} for listing #{@new_listing.name} on ArkleBnb")
    text_content = "Thank you, #{session[:name]} for listing #{@new_listing.name} on ArkleBnb"
    new_text = Text.new
    new_text.send_text(text_content)

    return erb(:create_listing)
  end

  get '/listings' do
    repo = ListingRepository.new
    @listings = repo.all

    return erb(:listings)
  end

  # Prevent requesting an already booked listing
    # check if request is valid?
    # check in sql if booked_status is true
    # if booked_status is true, throw error else make booking

  post '/book_a_night/:listing_id' do
    repo = DatesListRepository.new
    @listing_id = params[:listing_id]
    dates_list = repo.find_by_listing_as_objects(@listing_id)

    dates_list.each do |date_list|
      if params[:date] == date_list.date
        @date_list_id = date_list.id
        break
      end
    end
    
    if @date_list_id.nil?
      status 400
      @error = 'Listing not available'
      return erb(:booking_error)
    elsif repo.find_by_date_list_id_as_object(@date_list_id).booked_status == 't'
      status 400
      @error = 'Listing already booked'
      return erb(:booking_error)
    else
      request_repo = RequestsRepository.new
      request = Request.new
      request.user_id = session[:user_id]
      request.date_list_id = @date_list_id
      request_repo.create(request)
      # send_email(session[:email], 'Request made!', "Hello, #{session[:name]}, your request to book a listing on ArkleBnb")
      text_content = "Hello, #{session[:name]}, your request to book a listing on ArkleBnb has been sent"
      new_text = Text.new
      new_text.send_text(text_content)

      return erb(:booking_requested)
    end
  end

  get '/listings/:listing_id' do
    repo = ListingRepository.new
    listing_id = params[:listing_id]
    @listing = repo.find(listing_id)
    @dates_list = DatesListRepository.new.find_by_listing_as_objects(listing_id)

    return erb(:listing)
  end

  get '/account' do 
    requestrepo = RequestsRepository.new 
    @requests = requestrepo.find_requests_by_requester_user_id(session[:user_id])
    @booking_requests = requestrepo.find_requests_by_listing_user_id(session[:user_id])
    return erb(:account)
  end

  post '/approve_request' do
    datelistrepo = DatesListRepository.new
    if datelistrepo.find_by_date_list_id(params[:date_list_id])[0]['booked_status'] == 'f' 
      newstatus = 'TRUE'
      newbooker = params[:requester_id]
    else
      newstatus = 'FALSE'
      newbooker = '0'
    end
      datelistrepo.update_booked_status(params[:date_list_id], newstatus, newbooker)
    redirect ('/account')
  end

end


#TODO
  # Write email queries for request approved, request denied, someone has requested to book your property.