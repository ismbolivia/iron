require 'test_helper'

class BoxPurchaseOrderPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @box_purchase_order_payment = box_purchase_order_payments(:one)
  end

  test "should get index" do
    get box_purchase_order_payments_url
    assert_response :success
  end

  test "should get new" do
    get new_box_purchase_order_payment_url
    assert_response :success
  end

  test "should create box_purchase_order_payment" do
    assert_difference('BoxPurchaseOrderPayment.count') do
      post box_purchase_order_payments_url, params: { box_purchase_order_payment: { amount: @box_purchase_order_payment.amount, box_id: @box_purchase_order_payment.box_id, purchase_order_id: @box_purchase_order_payment.purchase_order_id } }
    end

    assert_redirected_to box_purchase_order_payment_url(BoxPurchaseOrderPayment.last)
  end

  test "should show box_purchase_order_payment" do
    get box_purchase_order_payment_url(@box_purchase_order_payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_box_purchase_order_payment_url(@box_purchase_order_payment)
    assert_response :success
  end

  test "should update box_purchase_order_payment" do
    patch box_purchase_order_payment_url(@box_purchase_order_payment), params: { box_purchase_order_payment: { amount: @box_purchase_order_payment.amount, box_id: @box_purchase_order_payment.box_id, purchase_order_id: @box_purchase_order_payment.purchase_order_id } }
    assert_redirected_to box_purchase_order_payment_url(@box_purchase_order_payment)
  end

  test "should destroy box_purchase_order_payment" do
    assert_difference('BoxPurchaseOrderPayment.count', -1) do
      delete box_purchase_order_payment_url(@box_purchase_order_payment)
    end

    assert_redirected_to box_purchase_order_payments_url
  end
end
