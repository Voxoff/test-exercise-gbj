require "rails_helper"
require_relative "../../lib/tasks/delivery_helper"

RSpec.describe DeliveryHelper do
  describe '#orders_to_deliver' do
    subject { DeliveryHelper.new(date: Date.today).orders_to_deliver }

    context 'when there are valid orders' do
      it 'should return the valid orders' do
        order = create(:order)
        expect(subject).to contain_exactly(order)
      end
    end

    context 'when there are no orders' do
      it 'should be empty' do
        expect(subject).to be_empty
      end
    end

    context 'when there are no billed orders' do
      before do
        create(:order, state: 'complete')
      end
      it 'should be empty' do
        expect(subject).to be_empty
      end
    end

    context 'when there are orders but none on the required day' do
      before do
        Timecop.freeze(Date.today - 1.days) do
          create(:order)
        end
      end
      it 'should be empty' do
        expect(subject).to be_empty
      end
    end

    context 'when the orders already have deliveries' do
      before do
        create(:order_with_delivery)
      end
      it 'should be empty' do
        expect(subject).to be_empty
      end
    end
  end

  describe '#delivery_date' do
    let(:delivery_helper) { DeliveryHelper.new(date: Date.today) }
    subject { delivery_helper.delivery_date(order) }

    context 'free shipping' do
      let(:order) { create(:order) }
      it 'calls first_available_free_date' do
        expect(delivery_helper).to receive(:first_available_free_date)
        subject
      end
    end

    context 'premium shipping' do
      let(:order) { create(:order, :premium_shipping) }
      it 'calls the date orderd' do
        expect(delivery_helper).to receive(:date)
        subject
      end
    end
  end

  describe '#calculate_available_day' do
    subject { DeliveryHelper.new(date: date) }

    context 'not on a bank holiday' do
      let(:date) { Date.today }
      it 'should return the same day' do
        expect(subject.first_available_free_date).to eq date
      end
    end

    context 'on a bank holiday' do
      let(:date) { Date.parse('2020-08-31') }
      it 'should return the next day' do
        expect(subject.first_available_free_date).to eq date.tomorrow
      end
    end

    context 'on a bank holiday followed by a bank holiday' do
      let(:date) { Date.parse('2021-12-27') }
      it 'should return the next day' do
        allow_any_instance_of(DeliveryHelper).to receive(:bank_holidays).and_return([
          Date.parse('2021-12-27'),
          Date.parse('2021-12-28'),
          Date.parse('2022-01-01')
        ])
        expect(subject.first_available_free_date).to eq date.tomorrow.tomorrow
      end
    end

    context 'on a date afer the last bank holiday known' do
      let(:date) { Date.parse('2022-12-27') }
      it 'should raise an argument error' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end

  describe '#bank_holiday_file' do
    it 'returns a valid file' do
      file = DeliveryHelper.new(date: Date.today).bank_holiday_file
      expect(file.file?).to eq true
    end
  end

   describe '#create_deliveries' do
    let(:date) { Date.parse("2020-06-26") }
    let(:bank_holiday) { Date.parse("2020-08-31") }
    subject { DeliveryHelper.new(date: date).create_deliveries }

    before(:each) do
      Timecop.travel(date) do
        create(:order)
      end
    end

    it 'ensures delivery is created only if order is also updated' do
      order = create(:order)
      allow(Delivery).to receive(:create).and_raise(StandardError)
      expect(order.reload.state).to eq 'billed'
    end

    it 'gets the orders in need of deliveries' do
      expect_any_instance_of(DeliveryHelper).to receive(:orders_to_deliver).and_call_original
      subject
    end

    it 'should create deliveries' do
      expect { subject }.to change { Delivery.count }.from(0).to(1)
    end

    it 'should update the order' do
      expect_any_instance_of(Order).to receive(:update).with(state: 'complete')
      subject
    end
  end
end
