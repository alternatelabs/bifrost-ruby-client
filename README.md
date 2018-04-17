# Bifrost Ruby Client

[![Build Status](https://travis-ci.org/alternatelabs/bifrost-ruby-client.svg?branch=master)](https://travis-ci.org/alternatelabs/bifrost-ruby-client)

A ruby client library for the [bifrost crystal](https://github.com/alternatelabs/bifrost) websockets server.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bifrost-client'
```

And then execute:

```sh
$ bundle
```

## Configuration

By default Bifrost::Client will look for environment variables:

```sh
JWT_SECRET=9c3ed1aa0ba8405effdb363839caa3cc
BIFROST_URL=https://bifrost-server.myapp.com
```

And you can create a Bifrost client like so:

```ruby
client = Bifrost::Client.new
```

Or you can pass in configuration directly:

```ruby
client = Bifrost::Client.new(
  jwt_secret: "9c3ed1aa0ba8405effdb363839caa3cc",
  bifrost_server_url: "https://bifrost-server.myapp.com"
)
```

## Usage

### Token helper

This helps you generate a JWT to give an end user permission to connect to a channel called `user:thor`

```ruby
token = client.token_for(channels: %w[user:thor]) # => "eyJhbGciOiJIUzUxMiJ9.eyJjaGFubmVscyI6WyJ1c2VyOnRob3IiXX0.SBgGNE-n7S8gVtYQ3wg7_WG2TqOGNFf-jy0GW57_YV-B-xjekm4KCQwTZIqxL_TXoqbWW3tThT9YTt4GLD4Y7A"
```

Once you have this token [follow the instructions on the bifrost repo](https://github.com/alternatelabs/bifrost#1-create-an-api-endpoint-in-your-application-that-can-give-users-a-realtime-token) to provide that token to client side JS and connect using ReconnectingWebsocket.

### Broadcast events

Use `client#broadcast` when you want to send an event out to all members of a channel. Payload must be a string, we recommend you encode it to JSON and can safely `JSON.parse(payload)` in your client side code upon receiving the message.

```ruby
begin
  payload = JSON.dump({ name: "Hela" })
  channel = "user:thor"
  client.broadcast(channel, event: "invader_detected", data: payload) # => { deliveries: 1 }
rescue Bifrost::ServerError => e
  # Do something with the error
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alternatelabs/bifrost-ruby-client.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
