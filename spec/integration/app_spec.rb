require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # Write your integration tests below.
  # If you want to split your integration tests
  # accross multiple RSpec files (for example, have
  # one test suite for each set of related features),
  # you can duplicate this test file to create a new one.

  def reset_table 
    seed_sql = File.read("spec/seeds/bnb_reseeds.sql")
    connection = PG.connect({host: '127.0.0.1', dbname: 'bnb_test' })
    connection.exec(seed_sql)
  end


  before(:each) do
    reset_table
  end

  context 'GET /' do
    it 'should get the homepage' do
      response = get('/')

      expect(response.status).to eq(200)
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
    it "responds 200 OK" do
      response = get('/signup')
      expect(response.status).to eq 200
    end

    it "displays the form" do
      response = get('/signup')
      expect(response.body).to include('<label class="form__label" for="name">Full Name</label')
      expect(response.body).to include('><input class="form__input" type="text" id="name" />')
      expect(response.body).to include('><input class="form__input" type="password" id="password" />')
      expect(response.body).to include("You're one step away...")
      expect(response.body).to include("Please enter your details to create an account.")
    end
  end

  context 'GET /login' do
    it "responds 200 OK" do
      response = get('/login')
      expect(response.status).to eq 200
    end

    it "displays the form" do
      response = get('/login')
      expect(response.body).to include('<label class="form__label" for="email">Email</label')
      expect(response.body).to include('><input class="form__input" type="email" id="email" />')
      expect(response.body).to include('><input class="form__input" type="password" id="password" />')
      expect(response.body).to include("Welcome back!")
      expect(response.body).to include("Please enter your details to login to ArkleBnb")
    end
  end
  context "POST to '/signup'" do
    it "can show success page" do
      response = post('/signup', name: "jeff", email: "jeff@jeffworld.com", password: "mynameajeff")
      expect(response.body).to include("Thank you jeff for signing up!")
    end
    it "can sign up a user" do
      post('/signup', name: "jeff", email: "jeff@jeffworld.com", password: "mynameajeff")
      repo = UserRepository.new
      expect(repo.show_all[4]["name"]).to eq "jeff"
    end
  end
end
