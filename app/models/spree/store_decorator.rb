Spree::Store.class_eval do
  # Solidus tries to use a simplified version of the address for this
  # (a Tax::TaxLocation). But for TaxJar we need more info than that object
  # is designed for so using the default address instead
  def default_cart_tax_location
    @default_cart_tax_location ||= Spree::Address.build_default
  end
end
