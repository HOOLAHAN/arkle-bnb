$LOAD_PATH << "lib"
require 'sinatra/base'
require 'sinatra/reloader'
require 'database_connection'
require 'user_repository'

DatabaseConnection.connect('bnb_test')

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  enable :sessions

  get '/' do
    if session[:name] == nil
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
end
