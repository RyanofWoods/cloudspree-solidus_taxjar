require 'spec_helper'

describe Spree::Reimbursement do

  let(:reimbursement) { create(:reimbursement) }
  let(:client) { double(Spree::Taxjar) }
  let(:rate) { create :tax_rate, calculator: Spree::Calculator::TaxjarCalculator.new(preferred_api_key: 'api-key') }

  describe 'Constants' do
    it 'should include Taxable' do
      expect(Spree::Order.include?(Taxable)).to eq true
    end
  end

  describe 'Instance Methods' do
    describe '#remove_tax_for_returned_items' do
      context 'when taxjar_rate is nil' do
        it 'should return nil' do
          expect(reimbursement.send(:remove_tax_for_returned_items)).to eq nil
        end
      end
      context 'when taxjar_applicable? return true' do
        before do
          @order = reimbursement.order
          allow(reimbursement).to receive(:taxjar_rate).with(@order).and_return(rate)
          allow(Spree::Taxjar).to receive(:new).with('api-key', @order, reimbursement).and_return(client)
          allow(client).to receive(:create_refund_transaction_for_order)
        end

        it 'should remive tax for reimbursed items' do
          expect(client).to receive(:create_refund_transaction_for_order)
        end

        after { reimbursement.remove_tax_for_returned_items }
      end
    end

  end

end
