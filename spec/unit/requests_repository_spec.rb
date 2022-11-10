require_relative '../../lib/requests_repository'

RSpec.describe RequestsRepository do

  def reset_table
    seed_sql = File.read('spec/seeds/bnb_reseeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'bnb_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_table
  end
  
  let(:requestslist) {RequestsRepository.new}
  
  context 'create method' do
    it 'can create a new request' do
      repo = RequestsRepository.new
      request = Request.new

      request.user_id = '1'
      request.date_list_id = '2'

      repo.create(request)
      expect(repo.all.length).to eq 9
    end
  end


  it "find_requests_by_requester_user_id(user_id)" do
    results = requestslist.find_requests_by_requester_user_id('1')
    expect(results.ntuples).to eq (3)
    expect(results[0]['date_list_id']).to eq ('24')
    expect(results[1]['date']).to eq ('2023-04-03')
  end

  it "find_requests_by_listing_user_id(user_id)" do
    results = requestslist.find_requests_by_listing_user_id('2')
    expect(results.ntuples).to eq 8
    expect(results[5]['date_list_id']).to eq ('24')
    expect(results[5]['requester_email']).to eq ('anna@gmail.com')
  end

end

