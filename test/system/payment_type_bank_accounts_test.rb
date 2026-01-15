require "application_system_test_case"

class PaymentTypeBankAccountsTest < ApplicationSystemTestCase
  setup do
    @payment_type_bank_account = payment_type_bank_accounts(:one)
  end

  test "visiting the index" do
    visit payment_type_bank_accounts_url
    assert_selector "h1", text: "Payment Type Bank Accounts"
  end

  test "creating a Payment type bank account" do
    visit payment_type_bank_accounts_url
    click_on "New Payment Type Bank Account"

    fill_in "Bank account", with: @payment_type_bank_account.bank_account_id
    fill_in "Monto", with: @payment_type_bank_account.monto
    fill_in "Payment type", with: @payment_type_bank_account.payment_type_id
    click_on "Create Payment type bank account"

    assert_text "Payment type bank account was successfully created"
    click_on "Back"
  end

  test "updating a Payment type bank account" do
    visit payment_type_bank_accounts_url
    click_on "Edit", match: :first

    fill_in "Bank account", with: @payment_type_bank_account.bank_account_id
    fill_in "Monto", with: @payment_type_bank_account.monto
    fill_in "Payment type", with: @payment_type_bank_account.payment_type_id
    click_on "Update Payment type bank account"

    assert_text "Payment type bank account was successfully updated"
    click_on "Back"
  end

  test "destroying a Payment type bank account" do
    visit payment_type_bank_accounts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Payment type bank account was successfully destroyed"
  end
end
