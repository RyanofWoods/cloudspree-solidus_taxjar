module Taxable
  extend ActiveSupport::Concern

  private
    def taxjar_applicable?(order)
      Spree::TaxRate.for_address(order.tax_address).any? { |rate| rate.calculator_type == "Spree::Calculator::TaxjarCalculator" }
    end
end
