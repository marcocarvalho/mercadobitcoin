class MercadoBitcoin::Console::Commands::Order::Sell < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
  short_desc 'place_sell_order'
  long_desc 'Abre uma ordem de venda (sell ou ask) do par de moedas, quantidade de moeda digital e preço unitário limite informados. A criação contempla o processo de confrontamento da ordem com o livro de negociações. Assim, a resposta pode informar se a ordem foi executada (parcialmente ou não) imediatamente após sua criação e, assim, se segue ou não aberta e ativa no livro.'

  def after_initialize
    argument_desc(quantity: 'Quantidade da moeda digital a comprar/vender ao preço de price. (até 8 decimais, separador decimal: .)'+"\n", price: 'Preço unitário máximo de compra ou mínimo de venda. (até 5 decimais, separador decimal: .)')
  end

  def execute(quantity, price)
    console.options[:quantity] = quantity.to_f
    console.options[:limit_price] = price.to_f
    super
  end
end