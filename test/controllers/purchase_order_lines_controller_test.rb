require 'test_helper'

class PurchaseOrderLinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @purchase_order_line = purchase_order_lines(:one)
  end

  test "should get index" do
    get purchase_order_lines_url
    assert_response :success
  end

  test "should get new" do
    get new_purchase_order_line_url
    assert_response :success
  end

  test "should create purchase_order_line" do
    assert_difference('PurchaseOrderLine.count') do
      post purchase_order_lines_url, params: { purchase_order_line: { company_id: @purchase_order_line.company_id, date_planned: @purchase_order_line.date_planned, item_id: @purchase_order_line.item_id, item_qty: @purchase_order_line.item_qty, name: @purchase_order_line.name, price_tax: @purchase_order_line.price_tax, price_unit: @purchase_order_line.price_unit, purchase_order: @purchase_order_line.purchase_order, purchase_order_id: @purchase_order_line.purchase_order_id, qty_received: @purchase_order_line.qty_received, state: @purchase_order_line.state } }
    end

    assert_redirected_to purchase_order_line_url(PurchaseOrderLine.last)
  end

  test "should show purchase_order_line" do
    get purchase_order_line_url(@purchase_order_line)
    assert_response :success
  end

  test "should get edit" do
    get edit_purchase_order_line_url(@purchase_order_line)
    assert_response :success
  end

  test "should update purchase_order_line" do
    patch purchase_order_line_url(@purchase_order_line), params: { purchase_order_line: { company_id: @purchase_order_line.company_id, date_planned: @purchase_order_line.date_planned, item_id: @purchase_order_line.item_id, item_qty: @purchase_order_line.item_qty, name: @purchase_order_line.name, price_tax: @purchase_order_line.price_tax, price_unit: @purchase_order_line.price_unit, purchase_order: @purchase_order_line.purchase_order, purchase_order_id: @purchase_order_line.purchase_order_id, qty_received: @purchase_order_line.qty_received, state: @purchase_order_line.state } }
    assert_redirected_to purchase_order_line_url(@purchase_order_line)
  end

  test "should destroy purchase_order_line" do
    assert_difference('PurchaseOrderLine.count', -1) do
      delete purchase_order_line_url(@purchase_order_line)
    end

    assert_redirected_to purchase_order_lines_url
  end
end
