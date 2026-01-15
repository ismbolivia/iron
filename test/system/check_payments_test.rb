require "application_system_test_case"

class CheckPaymentsTest < ApplicationSystemTestCase
  setup do
    @check_payment = check_payments(:one)
  end

  test "visiting the index" do
    visit check_payments_url
    assert_selector "h1", text: "Check Payments"
  end

  test "creating a Check payment" do
    visit check_payments_url
    click_on "New Check Payment"

    fill_in "Check", with: @check_payment.check_id
    fill_in "Payment", with: @check_payment.payment_id
    click_on "Create Check payment"

    assert_text "Check payment was successfully created"
    click_on "Back"
  end

  test "updating a Check payment" do
    visit check_payments_url
    click_on "Edit", match: :first

    fill_in "Check", with: @check_payment.check_id
    fill_in "Payment", with: @check_payment.payment_id
    click_on "Update Check payment"

    assert_text "Check payment was successfully updated"
    click_on "Back"
  end

  test "destroying a Check payment" do
    visit check_payments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Check payment was successfully destroyed"
  end
end
