require 'spec_helper'
require 'rack/test'
require_relative '../../app'
require 'json'

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  def reset_table
    seed_sql = File.read('spec/seeds/bnb_reseeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'bnb_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_table
  end

  context 'GET /' do
    it 'should get the homepage' do
      response = get('/')

      expect(response.status).to eq(200)
      expect(response.body).to include('class="link" href="/login"')
    end
    it 'returns alternate home when logged in' do
      post('/login', email: 'anna@gmail.com', password: '1234')
      response = get('/')
      expect(response.status).to eq(200)
      expect(response.body).to include('class="link" href="/logout">Logout')
    end
  end

  context 'GET /create_listing' do
    it 'should display the HTML content for create_listing.erb' do
      response = get('/create_listing')
      expect(response.status).to eq(200)
      expect(response.body).to include('List a Space')
    end
  end

  context 'GET listings' do
    it 'should return the html content for listings' do
      response = get('/listings')
      expect(response.status).to eq(200)
      expect(response.body).to include('Listings')
    end
  end

  context 'POST /listings' do
    it 'should return the form which generates a new listing' do
      response = post('/listings', name: 'Palacial Pad', description: 'A heavenly way to get away, no way!',
                                   night_price: 50_000, start_date: '2027-01-01', end_date: '2027-02-01')
      expect(response.status).to eq(200)
    end

    it 'should populate with user_id information' do
      post('/login', email: 'anna@gmail.com', password: '1234')
      response = post('/listings', name: 'Palacial Pad', description: 'A heavenly way to get away, no way!',
                                   night_price: 50_000, start_date: '2027-01-01', end_date: '2027-02-01')
      expect(response.status).to eq 200
      expect(ListingRepository.new.find('4').user_id).to eq 1
    end

    it 'should take start and end date from 2x fields' do
      post('/login', email: 'thehoax@gmail.com', password: 'unbelievable')
      post('/listings', name: 'Trump tower', description: 'I will be back', night_price: 250_000,
                        start_date: '2023-01-03', end_date: '2023-02-03')
      expect(DatesListRepository.new.find_by_listing('4')[0]['date']).to include('2023-01-03')
      # expect(DatesListRepository.new.find_by_listing('4')['date']).to include ('2023-02-03')
      # expect(DatesListRepository.new.find_by_listing('4')['date']).to include ('2023-01-20')
    end
  end

  context 'GET /listings/:listing_id' do
    it 'should return the HTML content for requesting an individual listing' do
      response = get('/listings/1')
      expect(response.status).to eq(200)
      expect(response.body).to include('ShittyShack')
      expect(response.body).to include('2023-01-20')
      expect(response.body).to include('2023-01-21')
      expect(response.body).not_to include('2023-01-23')
    end
  end

  context 'POST /book_a_night' do
    it 'should return the form which generates a booking request' do
      post('/login', email: 'anna@gmail.com', password: '1234')
      response = post('/book_a_night/3', date: '2023-02-02') # selecting dates_list_id 9
      expect(response.status).to eq(200)
      response = RequestsRepository.new.all
      expect(response.length).to eq 9
    end

    it 'should return the form which generates a booking request' do
      post('/login', email: 'anna@gmail.com', password: '1234')
      response = post('/book_a_night/3', date: '2023-02-02') # selecting dates_list_id 9
      expect(response.body).to include('Request received')
    end

    it 'should return error and status 400 when invalid date' do
      post('/login', email: 'anna@gmail.com', password: '1234')
      response = post('/book_a_night/3', date: '2000-01-01')

      expect(response.status).to eq 400
      expect(response.body).to include('Listing not available')
    end

    it 'should return error and status 400 when invalid pairing' do
      post('/login', email: 'anna@gmail.com', password: '1234')
      response = post('/book_a_night/3', date: '2023-01-20')

      expect(response.status).to eq 400
      expect(response.body).to include('Listing not available')
    end

    it " should return error and status 400 when attempting to request an already booked listing " do
      post('/login', email: 'anna@gmail.com', password: '1234')
      response = post('book_a_night/1', date: '2023-01-23')

      expect(response.status).to eq 400
      expect(response.body).to include('Listing already booked')
    end
  end

  context 'Get /welcome' do
    it 'should respond 200 OK' do
      response = get('/welcome')
      expect(response.status).to eq 200
    end

    it 'should contain some html data' do
      response = get('/welcome')
      expect(response.body).to include('<title>Arkle-BnB</title>')
      expect(response.body).to include(' <h1 class="blurb__header">Welcome!</h1>')
      expect(response.body).to include('Please Signup or Login.')
      expect(response.body).to include('<a class="link" href="/signup">SignUp</a>')
      expect(response.body).to include('<a class="link" href="/login">Login</a>')
    end
  end

  context 'GET /signup' do
    it 'responds 200 OK' do
      response = get('/signup')
      expect(response.status).to eq 200
    end

    it 'displays the form' do
      response = get('/signup')
      expect(response.body).to include('<label class="form__label" for="name">Full Name</label')
      expect(response.body).to include('<input class="form__input" type="text" name="name" />')
      expect(response.body).to include('<input class="form__input" type="password" name="password" />')
      expect(response.body).to include("You're one step away...")
      expect(response.body).to include('Please enter your details to create an account.')
    end
  end

  context 'GET /login' do
    it 'responds 200 OK' do
      response = get('/login')
      expect(response.status).to eq 200
    end

    it 'displays the form' do
      response = get('/login')
      expect(response.body).to include('<label class="form__label" for="email">Email</label')
      expect(response.body).to include('<input class="form__input" type="email" name="email" />')
      expect(response.body).to include('<input class="form__input" type="password" name="password" />')

      expect(response.body).to include('Welcome back!')
      expect(response.body).to include('Please enter your details to login to ArkleBnb')
    end
  end

  context "POST to '/signup'" do
    # it "can show success page" do
    #   response = post('/signup', name: "jeff", email: "jeff@jeffworld.com", password: "mynameajeff")
    #   expect(response.body).to include("Welcome, jeff, you are now logged in!")
    # end
    it 'can sign up a user' do
      post('/signup', name: 'jeff', email: 'jeff@jeffworld.com', password: 'mynameajeff')
      repo = UserRepository.new
      expect(repo.show_all[4]['name']).to eq 'jeff'
    end
  end

  context 'POST /login' do
    # it "can show success page" do
    #   response = post('/login', email: "anna@gmail.com", password:'1234')
    #   expect(response.status).to eq 200
    #   expect(response.body).to include "Welcome, Anna, you are now logged in!"
    # end

    it 'returns incorrect password' do
      response = post('/login', email: 'anna@gmail.com', password: '124')
      expect(response.status).to eq 400
      expect(response.body).to include 'password wrong'
    end

    context "get '/logout' logs you out" do
      it 'logs you out if you click the link' do
        get('/logout')
        response = get('/')
        expect(response.status).to eq 200
        expect(response.body).to include('<a class="link" href="/login">Login</a>')
        expect(response.body).to include('Please Signup or Login.')
      end
    end
  end

end
