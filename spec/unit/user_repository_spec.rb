require_relative '../../lib/user_repository'

RSpec.describe UserRepository do
  def reset_table 
    seed_sql = File.read("spec/seeds/bnb_reseeds.sql")
    connection = PG.connect({host: '127.0.0.1', dbname: 'bnb_test' })
    connection.exec(seed_sql)
  end


  before(:each) do
    reset_table
  end

  let(:repo) {UserRepository.new}

  it "can find all users" do
    expect(repo.show_all[0]["name"]).to eq 'Anna' 
    expect(repo.show_all[1]["password"]).to eq '666' 
  end
  
  it "can create a new user" do
    new_user = User.new
    new_user.name = 'jeff'
    new_user.email = 'jeff@jeffworld.com'
    new_user.password = 'mynameajeff'
    
    repo.create(new_user)
    expect(repo.show_all[4]["name"]).to eq 'jeff'
  end
end