require "application_system_test_case"

class CurrencyRatesTest < ApplicationSystemTestCase
  setup do
    @currency_rate = currency_rates(:one)
  end

  test "visiting the index" do
    visit currency_rates_url
    assert_selector "h1", text: "Currency Rates"
  end

  test "creating a Currency rate" do
    visit currency_rates_url
    click_on "New Currency Rate"

    fill_in "Company", with: @currency_rate.company_id
    fill_in "Create Uid", with: @currency_rate.create_uid
    fill_in "Currency", with: @currency_rate.currency_id
    fill_in "Currency Ref", with: @currency_rate.currency_ref
    fill_in "Name", with: @currency_rate.name
    fill_in "Rate", with: @currency_rate.rate
    fill_in "State", with: @currency_rate.state
    click_on "Create Currency rate"

    assert_text "Currency rate was successfully created"
    click_on "Back"
  end

  test "updating a Currency rate" do
    visit currency_rates_url
    click_on "Edit", match: :first

    fill_in "Company", with: @currency_rate.company_id
    fill_in "Create Uid", with: @currency_rate.create_uid
    fill_in "Currency", with: @currency_rate.currency_id
    fill_in "Currency Ref", with: @currency_rate.currency_ref
    fill_in "Name", with: @currency_rate.name
    fill_in "Rate", with: @currency_rate.rate
    fill_in "State", with: @currency_rate.state
    click_on "Update Currency rate"

    assert_text "Currency rate was successfully updated"
    click_on "Back"
  end

  test "destroying a Currency rate" do
    visit currency_rates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Currency rate was successfully destroyed"
  end
end
