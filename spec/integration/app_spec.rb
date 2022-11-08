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


  context 'GET /' do
    it 'should get the homepage' do
      response = get('/')

      expect(response.status).to eq(200)
    end
  end

  context 'GET /create_listing' do
    it 'should display the HTML content for create_listing.erb' do
      response = get('/create_listing')
      expect(response.status).to eq (200)
      expect(response.body).to include ('List a Space')
    end
  end

  context 'POST /listings' do
    it 'should return the form which generates a new listing' do
      response = post('/listings', name: 'Palacial Pad', description: 'A heavenly way to get away, no way!', night_price: 50000)
      expect(response.status).to eq (302)
    end
  end

  context 'GET /listing_request/:listing_id' do
    it 'should return the HTML content for requesting an individual listing' do
      response = get('/listing_request/1')
      expect(response.status).to eq (200)
      expect(response.body).to include ('ShittyShack')
    end
  end

  context 'POST /book_a_night' do
    it 'should return the form which generates a booking request' do
      response = post('/book_a_night', date_list_id: 1)
      expect(response.status).to eq (302)
    end
  end

end
