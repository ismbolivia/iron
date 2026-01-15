require 'test_helper'

class PaymentTypeBankAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment_type_bank_account = payment_type_bank_accounts(:one)
  end

  test "should get index" do
    get payment_type_bank_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_payment_type_bank_account_url
    assert_response :success
  end

  test "should create payment_type_bank_account" do
    assert_difference('PaymentTypeBankAccount.count') do
      post payment_type_bank_accounts_url, params: { payment_type_bank_account: { bank_account_id: @payment_type_bank_account.bank_account_id, monto: @payment_type_bank_account.monto, payment_type_id: @payment_type_bank_account.payment_type_id } }
    end

    assert_redirected_to payment_type_bank_account_url(PaymentTypeBankAccount.last)
  end

  test "should show payment_type_bank_account" do
    get payment_type_bank_account_url(@payment_type_bank_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_type_bank_account_url(@payment_type_bank_account)
    assert_response :success
  end

  test "should update payment_type_bank_account" do
    patch payment_type_bank_account_url(@payment_type_bank_account), params: { payment_type_bank_account: { bank_account_id: @payment_type_bank_account.bank_account_id, monto: @payment_type_bank_account.monto, payment_type_id: @payment_type_bank_account.payment_type_id } }
    assert_redirected_to payment_type_bank_account_url(@payment_type_bank_account)
  end

  test "should destroy payment_type_bank_account" do
    assert_difference('PaymentTypeBankAccount.count', -1) do
      delete payment_type_bank_account_url(@payment_type_bank_account)
    end

    assert_redirected_to payment_type_bank_accounts_url
  end
end
