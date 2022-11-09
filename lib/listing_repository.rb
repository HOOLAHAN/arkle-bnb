require_relative './listing'

class ListingRepository
  # return all listings as an array
  def all
    sql = 'SELECT * FROM listings'
    result_set = DatabaseConnection.exec_params(sql, [])

    listings = []
    result_set.each do |record|
      listing = Listing.new
      listing.id = record['id']
      listing.user_id = record['user_id'].to_i
      listing.name = record['name']
      listing.description = record['description']
      listing.night_price = record['night_price'].to_i
      listings << listing
    end
    listings
  end

  # select an individual listing by id
  def find(id)
    # return a listing instance
    sql = 'SELECT * FROM listings WHERE id = $1'
    result_set = DatabaseConnection.exec_params(sql, [id])
    record = result_set[0]

    listing = Listing.new
    listing.id = record['id'].to_i
    listing.user_id = record['user_id'].to_i
    listing.name = record['name']
    listing.description = record['description']
    listing.night_price = record['night_price'].to_i
    listing
  end

  # create a new listing from listing instance
  def create(listing)
    sql = 'INSERT INTO listings (user_id, name, description, night_price) VALUES ($1, $2, $3, $4);'
    sql_params = [listing.user_id, listing.name, listing.description, listing.night_price]
    DatabaseConnection.exec_params(sql, sql_params)
    sql2 = 'select id from listings where name = $1'
    params = [listing.name]
    result = DatabaseConnection.exec_params(sql2, params)[0]['id'] # Returns unique id of just created listing
  end

end
