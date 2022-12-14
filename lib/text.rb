require 'twilio-ruby'

class Text

  def send_text(text_content)
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token = ENV['TWILIO_AUTH_TOKEN']
    mobile_number = ENV['IH_MOBILE']
    twilio_number = ENV['TWILIO_NUMBER']
    @client = Twilio::REST::Client.new(account_sid, auth_token)
    message = @client.messages.create(
    body: "#{text_content}",
    from: "#{twilio_number}",
    to: "#{mobile_number}"
    )
  end

end

