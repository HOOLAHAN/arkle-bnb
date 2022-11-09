require_relative '../../lib/requests_repository'

RSpec.describe RequestsRepository do
  def reset_table 
    seed_sql = File.read("spec/seeds/bnb_reseeds.sql")
    connection = PG.connect({host: '127.0.0.1', dbname: 'bnb_test' })
    connection.exec(seed_sql)
  end


  before(:each) do
    reset_table
  end
  context "create method" do
    it "can create a new request" do
      repo = RequestsRepository.new
      request = Request.new
      
      request.user_id = '1'
      request.date_list_id = '2'

      repo.create(request)
      expect(repo.all.length).to eq 9
    end
  end
end