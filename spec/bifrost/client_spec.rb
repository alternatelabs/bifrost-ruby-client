RSpec.describe Bifrost::Client do
  it "has a version number" do
    expect(Bifrost::Client::VERSION).not_to be nil
  end

  describe "#initialize" do
    let(:jwt_secret) { "9c3ed1aa0ba8405effdb363839caa3cc" }
    let(:server_url) { "https://bifrost.example.org" }

    it "can be instantiated with a JWT secret and bifrost server URL" do
      client = Bifrost::Client.new(
        jwt_secret: jwt_secret,
        bifrost_server_url: server_url
      )

      expect(client.jwt_secret).to eq(jwt_secret)
      expect(client.bifrost_server_url).to eq(server_url)
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
    it "broadcasts messages to bifrost server"
  end

  describe "#token" do
    it "generates JWTs for allowed channels"
  end
end
