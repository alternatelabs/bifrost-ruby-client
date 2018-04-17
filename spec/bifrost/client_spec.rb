RSpec.describe Bifrost::Client do
  let(:jwt_secret) { "9c3ed1aa0ba8405effdb363839caa3cc" }
  let(:server_url) { "https://bifrost.example.org" }
  subject do
    client = Bifrost::Client.new(
      jwt_secret: jwt_secret,
      bifrost_server_url: server_url
    )
  end

  it "has a version number" do
    expect(Bifrost::Client::VERSION).not_to be nil
  end

  describe "#initialize" do
    it "can be instantiated with a JWT secret and bifrost server URL" do
      expect(subject.jwt_secret).to eq(jwt_secret)
      expect(subject.bifrost_server_url).to eq(server_url)
    end

    it "defaults to fetching configuration from environment variables" do
      allow(ENV).to receive(:[]).with("JWT_SECRET").and_return("123456")
      allow(ENV).to receive(:[]).with("BIFROST_URL").and_return("http://bifrost2.example.org")

      client = Bifrost::Client.new

      expect(client.jwt_secret).to eq("123456")
      expect(client.bifrost_server_url).to eq("http://bifrost2.example.org")
    end
  end

  describe "#broadcast" do
    let(:channel) { "user:1" }
    let(:bifrost_resp) { JSON.dump({message: "Success", deliveries: 1}) }
    let(:resp_headers) { { "Content-Type" => "application/json", "Content-Length" => bifrost_resp.length } }

    context "when bifrost responds successfully" do
      it "broadcasts messages to bifrost server" do
        stub_request(:post, %r{#{server_url}})
          .to_return(body: bifrost_resp, status: 200, headers: resp_headers)

        result = subject.broadcast(channel, event: "event_name", data: "test")

        expect(result).to eq({message: "Success", deliveries: 1})

        expect(WebMock).to(have_requested(:post, "#{server_url}/broadcast").with { |req|
          payload = JSON.parse(req.body)["token"]
          expect(decode_jwt(payload)).to eq(
            "channel" => channel,
            "exp" => Time.now.to_i + 3600,
            "message" => {
              "event" => "event_name",
              "data" => "test"
            }
          )
        })
      end
    end

    context "when bifrost responds negatively" do
      it "returns false" do
        stub_request(:post, %r{#{server_url}})
          .to_return(body: bifrost_resp, status: 400, headers: resp_headers)

        expect do
          subject.broadcast(channel, event: "event_name", data: "test")
        end.to raise_error(Bifrost::ServerError)
      end
    end
  end

  describe "#token_for(channels:)" do
    it "generates JWTs for allowed channels" do
      jwt = subject.token_for(channels: %w[global agent:47])

      decoded = decode_jwt(jwt)

      expect(decoded["channels"]).to eq(%w[global agent:47])
    end
  end

  def decode_jwt(payload)
    JWT.decode(payload, jwt_secret, true, { algorithm: "HS512" })[0]
  end
end
