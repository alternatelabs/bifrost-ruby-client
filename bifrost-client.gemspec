
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bifrost/client/version"

Gem::Specification.new do |spec|
  spec.name          = "bifrost-client"
  spec.version       = Bifrost::Client::VERSION
  spec.authors       = ["Pete Hawkins"]
  spec.email         = ["pete@alternatelabs.co"]
  spec.metadata      = { "source_code_uri" => "https://github.com/alternatelabs/bifrost-ruby-client" }

  spec.summary       = %q{Ruby client library for the bifrost crystal websocket server}
  spec.description   = %q{Bifrost is a crystal websocket server, this is a client library to simplify broadcasting messages to it.}
  spec.homepage      = "https://github.com/alternatelabs/bifrost"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "jwt", ">= 2.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock"
end
