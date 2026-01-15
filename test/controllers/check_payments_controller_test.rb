require 'test_helper'

class CheckPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @check_payment = check_payments(:one)
  end

  test "should get index" do
    get check_payments_url
    assert_response :success
  end

  test "should get new" do
    get new_check_payment_url
    assert_response :success
  end

  test "should create check_payment" do
    assert_difference('CheckPayment.count') do
      post check_payments_url, params: { check_payment: { check_id: @check_payment.check_id, payment_id: @check_payment.payment_id } }
    end

    assert_redirected_to check_payment_url(CheckPayment.last)
  end

  test "should show check_payment" do
    get check_payment_url(@check_payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_check_payment_url(@check_payment)
    assert_response :success
  end

  test "should update check_payment" do
    patch check_payment_url(@check_payment), params: { check_payment: { check_id: @check_payment.check_id, payment_id: @check_payment.payment_id } }
    assert_redirected_to check_payment_url(@check_payment)
  end

  test "should destroy check_payment" do
    assert_difference('CheckPayment.count', -1) do
      delete check_payment_url(@check_payment)
    end

    assert_redirected_to check_payments_url
  end
end
