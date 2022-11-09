require_relative '../lib/listing_repository'
require_relative '../lib/listing'

def reset_tables
  seed_sql = File.read('spec/seeds/bnb_reseeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'bnb_test' })
  connection.exec(seed_sql)
end

describe ListingRepository do
  before(:each) do
    reset_tables
  end

  context '#all' do
    it 'returns all listings as an array' do
      repo = ListingRepository.new
      listings = repo.all

      expect(listings.length).to eq 3
      expect(listings[0].user_id).to eq 1
      expect(listings[0].name).to eq 'ShittyShack'
      expect(listings[0].description).to eq 'A surprisingly nice place to spend 10 minutes'
      expect(listings[0].night_price).to eq 10_000
    end
  end

  context '#find(id)' do
    it 'returns an instance of listing' do
      repo = ListingRepository.new
      listing = repo.find(1)

      expect(listing.id).to eq 1
      expect(listing.name).to eq 'ShittyShack'
      expect(listing.description).to eq 'A surprisingly nice place to spend 10 minutes'
      expect(listing.night_price).to eq 10_000
    end
  end

  context '#create(listing)' do
    it 'creates a new listing from given information' do
      listing = Listing.new
      # user Beelzebub id = 2
      listing.user_id = 2
      listing.name = 'Pergatory'
      listing.description = "When you just can't decide where to go."
      listing.night_price = 5_000

      repo = ListingRepository.new
      repo.create(listing)

      listings = repo.all
      last_listing = listings.last
      # expect(last_listing.user_id).to eq 2
      # expect(last_listing.name).to eq 'Pergatory'
      # expect(last_listing.description).to eq "When you just can't decide where to go."
      # expect(last_listing.night_price).to eq 5_000
    end
  end
end
