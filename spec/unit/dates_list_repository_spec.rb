require_relative '../../lib/dates_list_repository'

RSpec.describe DatesListRepository do
  def reset_table 
    seed_sql = File.read("spec/seeds/bnb_reseeds.sql")
    connection = PG.connect({host: '127.0.0.1', dbname: 'bnb_test' })
    connection.exec(seed_sql)
  end


  before(:each) do
    reset_table
  end

  let(:dateslist) {DatesListRepository.new}

  it "add_dates adds available dates to dates_list table" do
    dateslist.add_dates('1', '2026-01-01', '2026-02-02')
    expect(dateslist.find_by_listing_dates('1')).to include ('2026-01-20')
  end

  it "find_by_listing(id) finds all data available for a listing" do
    expect(dateslist.find_by_listing('3')[0]['date']).to eq '2023-02-02'  
  end

  it "find_by_listing_dates(id) returns array of dates" do
    expect(dateslist.find_by_listing_dates('3')).to include ('2023-02-06')
  end


end