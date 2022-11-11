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

  it "show_all_messages_in_thread correctly shows messages" do
    expect(convolist.show_all_messages_in_thread('4','1','4','1')[1]['message_content']).to eq ("i hear macdonalds is nice this time of year")
  end
  
  it "adds new message to thread" do
    convolist.add_new_message('1','4','NEW MESSAGE!!!!')
    expect(convolist.show_all_messages_in_thread('4','1','4','1')[0]['message_content']).to eq ("NEW MESSAGE!!!!")
  end

end
