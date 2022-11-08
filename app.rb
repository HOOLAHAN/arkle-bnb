require 'sinatra/base'
require 'sinatra/reloader'


class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
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
    @user = params[:name]
    new_user = User.new
    new_user.name = params[:name]
    new_user.email = params[:email]
    new_user.password = params[:password]

    UserRepository.new.create(new_user)
    
    return erb(:menu_page)
  end
end