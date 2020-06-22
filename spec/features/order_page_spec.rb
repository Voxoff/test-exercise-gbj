require 'rails_helper'

feature 'Order creation' do
  let!(:harper_bouquet) { create(:bouquet, :harper) }
  let!(:alexa_bouquet) { create(:bouquet, :alexa) }
  let!(:adrian_bouquet) { create(:bouquet, :adrian) }

  let!(:single_delivery) { create(:order_type, :single_delivery) }
  let!(:three_month_bundle) { create(:order_type, :three_month_bundle) }

  let!(:free_shipping_option) { create(:shipping_option, :free) }
  let!(:premium_shipping_option) { create(:shipping_option, :premium) }

  scenario 'Able to create a order from the order page' do
    visit('/')
    click_link 'New Order'
    within('#order_form') do
      select single_delivery, from: 'order_order_type_id'
      fill_in 'Recipient name', with: 'Gee'
      select adrian_bouquet, from: 'order_bouquet_id'
      fill_in 'order_first_delivery_date', with: '13/08/2019'
      select premium_shipping_option, from: 'order_shipping_option_id'
      click_button 'Create Order'
    end
    expect(page).to have_content 'Order was successfully created.'
  end
end
