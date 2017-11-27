module Taxable
  extend ActiveSupport::Concern

  def taxjar_rate order
    Spree::TaxRate.for_address(order.tax_address).to_a.find { |rate| rate.calculator_type == "Spree::Calculator::TaxjarCalculator" }
  end
end
