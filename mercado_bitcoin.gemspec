# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mercado_bitcoin/version'

Gem::Specification.new do |spec|
  spec.name          = "mercado_bitcoin"
  spec.version       = MercadoBitcoin::VERSION
  spec.authors       = ["Marco Carvalho"]
  spec.email         = ["marco@mcorp.io"]

  spec.summary       = %q{Thin layer over public price api of MercadoBitcoin.com.br}
  spec.description   = %q{Thin layer over public price api of MercadoBitcoin.com.br for more information about the API see https://www.mercadobitcoin.com.br/api }
  spec.homepage      = "https://github.com/marcocarvalho/mercadobitcoin"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'virtus', '~> 1.0'
  spec.add_dependency 'rest-client', '~> 1.8'
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "byebug", "~> 8.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
end
