require 'openssl'

module MercadoBitcoin
  class TradeApi
    using QueryStringRefinement

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
        'Sign': signature,
        'Content-Type': 'application/x-www-form-urlencoded'
      }
    end

    def sign(string_or_hash)
      string_or_hash = string_or_hash.to_query_string if string_or_hash.is_a?(Hash)
      hmac = OpenSSL::HMAC.new(code, OpenSSL::Digest.new('sha512'))
      hmac.update(string_or_hash).to_s
    end
  end
end