require 'twilio-ruby'

module Smsable

  def send_sms(number, text)
    @client = Twilio::REST::Client.new

    @client.messages.create(
      from: ENV['SMS_FROM'],
      to: number,
      body: text
    )
  end
end
