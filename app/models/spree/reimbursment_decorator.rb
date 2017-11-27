Spree::Reimbursement.class_eval do
  include Taxable

  state_machine = self.state_machines[:reimbursement_status]
  state_machine.after_transition to: [:reimbursed], do: :remove_tax_for_returned_items

  def remove_tax_for_returned_items
    rate = taxjar_rate order
    return unless rate
    client = Spree::Taxjar.new(rate.calculator.preferred_api_key, order, self)
    client.create_refund_transaction_for_order
  end
end
