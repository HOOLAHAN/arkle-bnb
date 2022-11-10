require_relative '../../lib/converse_repository'

RSpec.describe ConverseRepository do
  def reset_table 
    seed_sql = File.read("spec/seeds/bnb_reseeds.sql")
    connection = PG.connect({host: '127.0.0.1', dbname: 'bnb_test' })
    connection.exec(seed_sql)
  end


  before(:each) do
    reset_table
  end

  let(:convolist) {ConverseRepository.new}

  it "first test" do

  end

end
