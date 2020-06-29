require "rails_helper"
Rails.application.load_tasks

RSpec.describe "shipping.rake" do
  subject { run_task(task_name: "shipping", args: date) }

  context 'when a valid non-bank holiday date is format is provided' do
    before { Timecop.freeze(Date.parse(date)) }
    after { Timecop.return }
    let(:date) { "2020-06-26" }

    it "creates a delivery on the correct date and updates the order" do
      order = create(:order)
      delivery_date = Date.parse(date)
      subject
      expect(order.reload.state).to eq 'complete'
      expect(Delivery.count).to eq 1
      expect(Delivery.last.delivery_date).to eq delivery_date
    end
  end

  context 'when a valid bank holiday date is format is provided' do
    before { Timecop.freeze(Date.parse(date)) }
    after { Timecop.return }
    let(:date) { '2020-08-31' }

    it "creates a delivery on the correct date and updates the order" do
      order = create(:order)
      delivery_date = Date.parse(date) + 1.day
      subject
      expect(order.reload.state).to eq 'complete'
      expect(Delivery.count).to eq 1
      expect(Delivery.last.delivery_date).to eq delivery_date
    end
  end

  context 'when an invalid date format is provided' do
    let(:date) { '🌴' }
    it 'advises user of required format' do
      output = capture_stdout { subject }
      expect(output.index(/Expects date format: yyyy-mm-dd/)).to be_truthy
      expect(output.index(/Orders created/)).to be_falsey
    end
  end
end

