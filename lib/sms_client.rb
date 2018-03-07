class SMSClient
  cattr_accessor :client

  def initialize
    @client = Twilio::REST::Client.new(
      ENV.fetch('TWILIO_ACCOUNT_SID'),
      ENV.fetch('TWILIO_AUTH_TOKEN')
    )
  end

  def send_message(to, body, media = [])
    @client.messages.create(
      messaging_service_sid: ENV['TWILIO_SERVICE_ID'],
      to: to.to_s,
      body: body,
      media_url: media
    )
  end
end
