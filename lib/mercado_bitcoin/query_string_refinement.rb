module MercadoBitcoin::QueryStringRefinement
  refine Hash do
    def to_query_string
      URI.encode_www_form(self)
    end
  end
end