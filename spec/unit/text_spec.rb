require 'text'

describe Text do

  it 'sends a confirmation text' do
    text = Text.new
    result = text.send_text("test")
    expect(result.to_s).to include "MessageInstance"
  end

end

