class FakeSMS
  Message = Struct.new(:to, :body, :media_url, :messaging_service_sid)
  FAKE_FROM = '1234567890'.freeze
  cattr_accessor :messages

  self.messages = []

  def initialize(_account_sid, _auth_token); end

  def self.send_message(_to, body, media = [])
    { body: body, media: media }
  end

  def messages
    self
  end

  def self.phone
    ENV['TWILIO_NUMBER']
  end

  def create(to:, body:, media_url: '', messaging_service_sid: '')
    self.class.messages << Message.new(to, body, media_url, messaging_service_sid)
  end
end
