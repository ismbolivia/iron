require 'test_helper'

class PaymentCurrenciesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment_currency = payment_currencies(:one)
  end

  test "should get index" do
    get payment_currencies_url
    assert_response :success
  end

  test "should get new" do
    get new_payment_currency_url
    assert_response :success
  end

  test "should create payment_currency" do
    assert_difference('PaymentCurrency.count') do
      post payment_currencies_url, params: { payment_currency: { currency_id: @payment_currency.currency_id, payment_type_id: @payment_currency.payment_type_id, sale_id: @payment_currency.sale_id } }
    end

    assert_redirected_to payment_currency_url(PaymentCurrency.last)
  end

  test "should show payment_currency" do
    get payment_currency_url(@payment_currency)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_currency_url(@payment_currency)
    assert_response :success
  end

  test "should update payment_currency" do
    patch payment_currency_url(@payment_currency), params: { payment_currency: { currency_id: @payment_currency.currency_id, payment_type_id: @payment_currency.payment_type_id, sale_id: @payment_currency.sale_id } }
    assert_redirected_to payment_currency_url(@payment_currency)
  end

  test "should destroy payment_currency" do
    assert_difference('PaymentCurrency.count', -1) do
      delete payment_currency_url(@payment_currency)
    end

    assert_redirected_to payment_currencies_url
  end
end
