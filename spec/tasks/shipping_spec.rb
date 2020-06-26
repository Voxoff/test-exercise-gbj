require "rails_helper"
Rails.application.load_tasks

RSpec.describe "shipping.rake" do
  subject { run_task(task_name: "shipping", args: date) }
  context 'when a valid date is format is provided' do
    let(:date) { Date.today.strftime("%y/%m/%d") }
    it "creates a delivery and updates the order" do
      expect(Delivery.count).to eq 0
      order = create(:order)
      subject
      expect(order.reload.state).to eq 'complete'
      expect(Delivery.count).to eq 1
    end
  end

  context 'when an invalid date format is provided' do
    let(:date) { '🌴' }
    it 'advises user of required format' do
      output = capture_stdout { subject }
      expect(output.index(/Expects date format: yy\/mm\/dd/)).to be_truthy
      expect(output.index(/Orders created/)).to be_falsey
    end
  end
end

