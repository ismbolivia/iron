require "application_system_test_case"

class DespositPaymentsTest < ApplicationSystemTestCase
  setup do
    @desposit_payment = desposit_payments(:one)
  end

  test "visiting the index" do
    visit desposit_payments_url
    assert_selector "h1", text: "Desposit Payments"
  end

  test "creating a Desposit payment" do
    visit desposit_payments_url
    click_on "New Desposit Payment"

    fill_in "Deposit", with: @desposit_payment.deposit_id
    fill_in "Payment", with: @desposit_payment.payment_id
    click_on "Create Desposit payment"

    assert_text "Desposit payment was successfully created"
    click_on "Back"
  end

  test "updating a Desposit payment" do
    visit desposit_payments_url
    click_on "Edit", match: :first

    fill_in "Deposit", with: @desposit_payment.deposit_id
    fill_in "Payment", with: @desposit_payment.payment_id
    click_on "Update Desposit payment"

    assert_text "Desposit payment was successfully updated"
    click_on "Back"
  end

  test "destroying a Desposit payment" do
    visit desposit_payments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Desposit payment was successfully destroyed"
  end
end
