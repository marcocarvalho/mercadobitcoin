module MercadoBitcoin::Api::Data::AskBidRefinement
  refine Array do
    def to_model_hash
      Hash[*[:price, :volume].zip(self).flatten]
    end
  end
end