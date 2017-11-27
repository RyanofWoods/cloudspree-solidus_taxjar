require 'spec_helper'

describe Spree::Order do

  let(:order) { create(:order) }
  let(:client) { double(Spree::Taxjar) }
  let(:rate) { create :tax_rate, calculator: Spree::Calculator::TaxjarCalculator.new(preferred_api_key: 'api-key') }

  describe 'Constants' do
    it 'should include Taxable' do
      expect(Spree::Order.include?(Taxable)).to eq true
    end
  end

  describe 'Instance Methods' do
    describe '#delete_taxjar_transaction' do
      context 'when taxjar_rate is nil' do
        it 'should return nil' do
          expect(order.send(:delete_taxjar_transaction)).to eq nil
        end
      end

      context 'when taxjar_rate is available' do
        before do
          allow(order).to receive(:taxjar_rate).with(order).and_return(rate)
          allow(Spree::Taxjar).to receive(:new).with('api-key', order).and_return(client)
          allow(client).to receive(:delete_transaction_for_order)
        end

        it 'should delete transaction for order' do
          expect(client).to receive(:delete_transaction_for_order)
        end

        after { order.send(:delete_taxjar_transaction) }
      end
    end

    describe '#capture_taxjar' do
      context 'when taxjar_rate is nil' do
        it 'should return nil' do
          expect(order.send(:capture_taxjar)).to eq nil
        end
      end

      context 'when taxjar_rate is available' do
        before do
          allow(order).to receive(:taxjar_rate).with(order).and_return(rate)
          allow(Spree::Taxjar).to receive(:new).with('api-key', order).and_return(client)
          allow(client).to receive(:create_transaction_for_order)
        end

        it 'should create transaction for order' do
          expect(client).to receive(:create_transaction_for_order)
        end

        after { order.send(:capture_taxjar) }
      end
    end
  end

end
