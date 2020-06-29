require 'rails_helper'

RSpec.describe DeliveriesController, type: :controller do
  describe 'GET show' do
    it 'assigns @delivery' do
      delivery = create(:delivery)
      get :show, params: { id: delivery.id, format: 'json' }
      expect(assigns(:delivery)).to eq(delivery)
    end
  end

  describe 'GET index' do
    it 'assigns @deliveries' do
      delivery = create(:delivery)
      get :index, params: { format: 'json' }
      expect(assigns(:deliveries)).to eq([delivery])
    end

    context 'valid date filter is provided' do
      let(:filter_date) { '2020-06-26' }
      it 'only returns deliveries created on the filtered date' do
        second_delivery = nil
        Timecop.travel(Date.parse(filter_date)) do
          second_delivery = create(:delivery)
        end
        get :index, params: { format: 'json', delivery_date: filter_date }
        expect(assigns(:deliveries)).to eq([second_delivery])
      end
    end

    context 'invalid date filter is provided' do
      let(:filter_date) { 'not_a_date' }
      it 'returns all deliveries' do
        delivery = create(:delivery)
        second_delivery = nil
        Timecop.travel(Date.parse('2020-06-26')) do
          second_delivery = create(:delivery)
        end
        get :index, params: { format: 'json', delivery_date: filter_date }
        expect(assigns(:deliveries)).to eq([delivery, second_delivery])
      end
    end
  end
end
