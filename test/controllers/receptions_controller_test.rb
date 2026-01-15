require 'test_helper'

class ReceptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reception = receptions(:one)
  end

  test "should get index" do
    get receptions_url
    assert_response :success
  end

  test "should get new" do
    get new_reception_url
    assert_response :success
  end

  test "should create reception" do
    assert_difference('Reception.count') do
      post receptions_url, params: { reception: { company_id: @reception.company_id, fecha: @reception.fecha, ob: @reception.ob, purchase_order_line_id: @reception.purchase_order_line_id, qty_in: @reception.qty_in, total: @reception.total, user_id: @reception.user_id, warehouse_id: @reception.warehouse_id } }
    end

    assert_redirected_to reception_url(Reception.last)
  end

  test "should show reception" do
    get reception_url(@reception)
    assert_response :success
  end

  test "should get edit" do
    get edit_reception_url(@reception)
    assert_response :success
  end

  test "should update reception" do
    patch reception_url(@reception), params: { reception: { company_id: @reception.company_id, fecha: @reception.fecha, ob: @reception.ob, purchase_order_line_id: @reception.purchase_order_line_id, qty_in: @reception.qty_in, total: @reception.total, user_id: @reception.user_id, warehouse_id: @reception.warehouse_id } }
    assert_redirected_to reception_url(@reception)
  end

  test "should destroy reception" do
    assert_difference('Reception.count', -1) do
      delete reception_url(@reception)
    end

    assert_redirected_to receptions_url
  end
end
