require 'test_helper'

class DespositPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @desposit_payment = desposit_payments(:one)
  end

  test "should get index" do
    get desposit_payments_url
    assert_response :success
  end

  test "should get new" do
    get new_desposit_payment_url
    assert_response :success
  end

  test "should create desposit_payment" do
    assert_difference('DespositPayment.count') do
      post desposit_payments_url, params: { desposit_payment: { deposit_id: @desposit_payment.deposit_id, payment_id: @desposit_payment.payment_id } }
    end

    assert_redirected_to desposit_payment_url(DespositPayment.last)
  end

  test "should show desposit_payment" do
    get desposit_payment_url(@desposit_payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_desposit_payment_url(@desposit_payment)
    assert_response :success
  end

  test "should update desposit_payment" do
    patch desposit_payment_url(@desposit_payment), params: { desposit_payment: { deposit_id: @desposit_payment.deposit_id, payment_id: @desposit_payment.payment_id } }
    assert_redirected_to desposit_payment_url(@desposit_payment)
  end

  test "should destroy desposit_payment" do
    assert_difference('DespositPayment.count', -1) do
      delete desposit_payment_url(@desposit_payment)
    end

    assert_redirected_to desposit_payments_url
  end
end
