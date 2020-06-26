require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should validate_presence_of(:recipient_name) }
  it { should validate_presence_of(:bouquet_id) }
  it { should validate_presence_of(:order_type_id) }
  it { should validate_presence_of(:shipping_option_id) }
  it { should validate_presence_of(:first_delivery_date) }

  describe '.create_deliveries_on' do
    subject { Order.create_deliveries_on(Date.today)}
    context 'when there are valid orders' do
      before do
        create(:order)
      end

      it 'should create deliveries' do
        expect { subject }.to change { Delivery.count }
      end

      it 'should update order' do
        expect_any_instance_of(Order).to receive(:update).with(state:  'complete')
        subject
      end
    end

    context 'when there are no orders' do
      it 'should not create any deliveries' do
        expect { subject }.not_to change { Delivery.count }
      end
      it 'should not update order' do
        expect_any_instance_of(Order).not_to receive(:update)
        subject
      end
    end

    context 'when there are no billed orders' do
      before do
        create(:order, state: 'complete')
      end
      it 'should not create any deliveries' do
        expect { subject }.not_to change { Delivery.count }
      end
      it 'should not update order' do
        expect_any_instance_of(Order).not_to receive(:update)
        subject
      end
    end

    context 'when there are no orders on required day' do
      before do
        Timecop.freeze(Date.today - 2.days) do
          create(:order)
        end
      end
      it 'should not create any deliveries' do
        expect { subject }.not_to change { Delivery.count }
      end
      it 'should not update order' do
        expect_any_instance_of(Order).not_to receive(:update)
        subject
      end
    end

    context 'when the orders already have deliveries' do
      before do
        create(:order_with_delivery)
      end
      it 'should not create any deliveries' do
        expect { subject }.not_to change { Delivery.count }
      end
      it 'should not update order' do
        expect_any_instance_of(Order).not_to receive(:update)
        subject
      end
    end
  end
end
