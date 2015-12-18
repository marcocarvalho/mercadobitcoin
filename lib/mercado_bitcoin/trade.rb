module MercadoBitcoin
  class Trade < BaseApiCall
    attr_accessor :tid, :from, :to
    def initialize(coin, opts = {})
      @tid  = opts[:tid] || opts[:since]
      @from = opts[:from]
      @to   = opts[:to]
      super(coin, opts)
    end

    def from_to
      return @from_to if @from_to
      if @from && @to
        @from_to = "#{from}/#{to}"
      else
        @from_to = @from || @to
      end
    end

    def action
      return @action if @action
      @action = bitcoin? ? 'trades' : 'trades_litecoin'
      if(from_to)
        @action = File.join(@action, from_to).freeze
      end
      @action
    end

    def params
      return {} unless tid 
      { tid: tid }
    end

    def base_url
      @base_url ||= "https://www.mercadobitcoin.net/api".freeze
    end

    def model
      Array
    end

    class Array < ::Array
      def initialize(collection)
        collection.each { |i| push(MercadoBitcoin::Api::Data::Trade.new(i)) }
      end
    end
  end
end