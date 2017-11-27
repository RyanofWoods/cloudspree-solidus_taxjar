Spree::Order.class_eval do
  include Taxable

  state_machine.after_transition to: :complete, do: :capture_taxjar
  state_machine.after_transition to: :canceled, do: :delete_taxjar_transaction
  state_machine.after_transition to: :resumed, from: :canceled, do: :capture_taxjar

  private

    def delete_taxjar_transaction
      rate = taxjar_rate self
      return unless rate
      client = Spree::Taxjar.new(rate.calculator.preferred_api_key, self)
      client.delete_transaction_for_order
    end

    def capture_taxjar
      rate = taxjar_rate self
      return unless rate
      client = Spree::Taxjar.new(rate.calculator.preferred_api_key, self)
      client.create_transaction_for_order
    end
end
