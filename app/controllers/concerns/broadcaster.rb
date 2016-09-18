class Broadcaster
  FAYE_URI = 'http://0.0.0.0:9292/faye'
  USER_CHANNEL = 'user_count'
  START_CHANNEL = 'start'

  # send data stored in msg (hash) through the channel
  def self.broadcast(channel, msg)
    message = { channel: channel, data: msg }
    uri = URI.parse(FAYE_URI)
    Net::HTTP::post_form(uri, message: message.to_json)
  end

  def self.full_channel(channel, group_code)
    File.join('/', group_code, channel)
  end
end