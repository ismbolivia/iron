require 'test_helper'

class PurchaseOrderLinesTaxesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @purchase_order_lines_tax = purchase_order_lines_taxes(:one)
  end

  test "should get index" do
    get purchase_order_lines_taxes_url
    assert_response :success
  end

  test "should get new" do
    get new_purchase_order_lines_tax_url
    assert_response :success
  end

  test "should create purchase_order_lines_tax" do
    assert_difference('PurchaseOrderLinesTax.count') do
      post purchase_order_lines_taxes_url, params: { purchase_order_lines_tax: { purchse_order_line_id: @purchase_order_lines_tax.purchse_order_line_id, tax_id: @purchase_order_lines_tax.tax_id } }
    end

    assert_redirected_to purchase_order_lines_tax_url(PurchaseOrderLinesTax.last)
  end

  test "should show purchase_order_lines_tax" do
    get purchase_order_lines_tax_url(@purchase_order_lines_tax)
    assert_response :success
  end

  test "should get edit" do
    get edit_purchase_order_lines_tax_url(@purchase_order_lines_tax)
    assert_response :success
  end

  test "should update purchase_order_lines_tax" do
    patch purchase_order_lines_tax_url(@purchase_order_lines_tax), params: { purchase_order_lines_tax: { purchse_order_line_id: @purchase_order_lines_tax.purchse_order_line_id, tax_id: @purchase_order_lines_tax.tax_id } }
    assert_redirected_to purchase_order_lines_tax_url(@purchase_order_lines_tax)
  end

  test "should destroy purchase_order_lines_tax" do
    assert_difference('PurchaseOrderLinesTax.count', -1) do
      delete purchase_order_lines_tax_url(@purchase_order_lines_tax)
    end

    assert_redirected_to purchase_order_lines_taxes_url
  end
end
