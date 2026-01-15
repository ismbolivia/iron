require 'test_helper'

class ItemsSuppliersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @items_supplier = items_suppliers(:one)
  end

  test "should get index" do
    get items_suppliers_url
    assert_response :success
  end

  test "should get new" do
    get new_items_supplier_url
    assert_response :success
  end

  test "should create items_supplier" do
    assert_difference('ItemsSupplier.count') do
      post items_suppliers_url, params: { items_supplier: { item_id: @items_supplier.item_id, state: @items_supplier.state, supplier_id: @items_supplier.supplier_id } }
    end

    assert_redirected_to items_supplier_url(ItemsSupplier.last)
  end

  test "should show items_supplier" do
    get items_supplier_url(@items_supplier)
    assert_response :success
  end

  test "should get edit" do
    get edit_items_supplier_url(@items_supplier)
    assert_response :success
  end

  test "should update items_supplier" do
    patch items_supplier_url(@items_supplier), params: { items_supplier: { item_id: @items_supplier.item_id, state: @items_supplier.state, supplier_id: @items_supplier.supplier_id } }
    assert_redirected_to items_supplier_url(@items_supplier)
  end

  test "should destroy items_supplier" do
    assert_difference('ItemsSupplier.count', -1) do
      delete items_supplier_url(@items_supplier)
    end

    assert_redirected_to items_suppliers_url
  end
end
