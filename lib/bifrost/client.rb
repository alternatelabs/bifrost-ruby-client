require "bifrost/client/version"
require "json"
require "jwt"

module Bifrost
  class Client
    VERSION = "0.1.0"

    attr_reader :jwt_secret, :bifrost_server_url

    def initialize(jwt_secret: ENV["JWT_SECRET"], bifrost_server_url: ENV["BIFROST_URL"])
      @jwt_secret = jwt_secret
      @bifrost_server_url = bifrost_server_url
    end

    # Your code goes here...
    def xbroadcast(channel, event:, data: nil)
      data = {
        channel: channel,
        message: {
          event: event,
          data: data
        },
        exp: Time.zone.now.to_i + 1.hour
      }
      jwt = JWT.encode(data, ENV["JWT_SECRET"], "HS512")
      url = ENV.fetch("REALTIME_SERVICE_URL")
      url += "/broadcast"

      req = HTTP.post(url, json: { token: jwt })

      if req.status > 206
        raise "Error communicating with Realtime service on URL: #{url}"
      end
    end
  end
end
