require "bifrost/client/version"
require "net/http"
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

    def broadcast(channel, event:, data: nil)
      data = {
        channel: channel,
        message: {
          event: event,
          data: data
        },
        exp: Time.now.to_i + 3600
      }
      jwt = JWT.encode(data, jwt_secret, "HS512")
      uri = URI.parse(bifrost_server_url)
      uri.path = "/broadcast"

      res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request                 = Net::HTTP::Post.new(uri.path)
        request.body            = JSON.dump(token: jwt)
        request["Content-Type"] = "application/json"
        http.request(request)
      end

      status = Integer(res.code)

      if status > 206
        false
      else
        true
      end
    end
  end
end
