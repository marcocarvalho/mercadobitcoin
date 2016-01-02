require 'openssl'

module MercadoBitcoin
  class TradeApi
    attr_accessor :key, :code

    def initialize(key:, code:)
      @key = key
      @code = code
    end

    def base_url
      @base_url ||= "https://www.mercadobitcoin.net/tapi".freeze
    end

    def header(signature)
      {
        'Key': key,
        'Sign': signature
      }
    end

    def sign(string)
      hmac = OpenSSL::HMAC.new(code, OpenSSL::Digest.new('sha512'))
      hmac.update(string).to_s
    end
  end
end