require "application_system_test_case"

class ItemsSuppliersTest < ApplicationSystemTestCase
  setup do
    @items_supplier = items_suppliers(:one)
  end

  test "visiting the index" do
    visit items_suppliers_url
    assert_selector "h1", text: "Items Suppliers"
  end

  test "creating a Items supplier" do
    visit items_suppliers_url
    click_on "New Items Supplier"

    fill_in "Item", with: @items_supplier.item_id
    fill_in "State", with: @items_supplier.state
    fill_in "Supplier", with: @items_supplier.supplier_id
    click_on "Create Items supplier"

    assert_text "Items supplier was successfully created"
    click_on "Back"
  end

  test "updating a Items supplier" do
    visit items_suppliers_url
    click_on "Edit", match: :first

    fill_in "Item", with: @items_supplier.item_id
    fill_in "State", with: @items_supplier.state
    fill_in "Supplier", with: @items_supplier.supplier_id
    click_on "Update Items supplier"

    assert_text "Items supplier was successfully updated"
    click_on "Back"
  end

  test "destroying a Items supplier" do
    visit items_suppliers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Items supplier was successfully destroyed"
  end
end
