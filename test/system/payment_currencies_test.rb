require "application_system_test_case"

class PaymentCurrenciesTest < ApplicationSystemTestCase
  setup do
    @payment_currency = payment_currencies(:one)
  end

  test "visiting the index" do
    visit payment_currencies_url
    assert_selector "h1", text: "Payment Currencies"
  end

  test "creating a Payment currency" do
    visit payment_currencies_url
    click_on "New Payment Currency"

    fill_in "Currency", with: @payment_currency.currency_id
    fill_in "Payment type", with: @payment_currency.payment_type_id
    fill_in "Sale", with: @payment_currency.sale_id
    click_on "Create Payment currency"

    assert_text "Payment currency was successfully created"
    click_on "Back"
  end

  test "updating a Payment currency" do
    visit payment_currencies_url
    click_on "Edit", match: :first

    fill_in "Currency", with: @payment_currency.currency_id
    fill_in "Payment type", with: @payment_currency.payment_type_id
    fill_in "Sale", with: @payment_currency.sale_id
    click_on "Update Payment currency"

    assert_text "Payment currency was successfully updated"
    click_on "Back"
  end

  test "destroying a Payment currency" do
    visit payment_currencies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Payment currency was successfully destroyed"
  end
end
