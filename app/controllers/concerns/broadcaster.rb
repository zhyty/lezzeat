class Broadcaster
  USER_CHANNEL = '/user_count'
  FAYE_URI = 'http://0.0.0.0:9292/faye'

  # send data stored in msg (hash) through the channel
  def self.broadcast(channel, msg)
    message = { channel: channel, data: msg }
    uri = URI.parse(FAYE_URI)
    Net::HTTP::post_form(uri, message: message.to_json)
  end
end