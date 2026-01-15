require "application_system_test_case"

class InventoryItemsTest < ApplicationSystemTestCase
  setup do
    @inventory_item = inventory_items(:one)
  end

  test "visiting the index" do
    visit inventory_items_url
    assert_selector "h1", text: "Inventory Items"
  end

  test "creating a Inventory item" do
    visit inventory_items_url
    click_on "New Inventory Item"

    fill_in "Code Item", with: @inventory_item.code_item
    fill_in "Description Item", with: @inventory_item.description_item
    fill_in "Inventory", with: @inventory_item.inventory_id
    fill_in "Item", with: @inventory_item.item_id
    fill_in "Name Item", with: @inventory_item.name_item
    fill_in "Price Purchase Total", with: @inventory_item.price_purchase_total
    fill_in "Price Sale Total", with: @inventory_item.price_sale_total
    fill_in "Quantity Product", with: @inventory_item.quantity_product
    fill_in "User", with: @inventory_item.user_id
    fill_in "Variance", with: @inventory_item.variance
    click_on "Create Inventory item"

    assert_text "Inventory item was successfully created"
    click_on "Back"
  end

  test "updating a Inventory item" do
    visit inventory_items_url
    click_on "Edit", match: :first

    fill_in "Code Item", with: @inventory_item.code_item
    fill_in "Description Item", with: @inventory_item.description_item
    fill_in "Inventory", with: @inventory_item.inventory_id
    fill_in "Item", with: @inventory_item.item_id
    fill_in "Name Item", with: @inventory_item.name_item
    fill_in "Price Purchase Total", with: @inventory_item.price_purchase_total
    fill_in "Price Sale Total", with: @inventory_item.price_sale_total
    fill_in "Quantity Product", with: @inventory_item.quantity_product
    fill_in "User", with: @inventory_item.user_id
    fill_in "Variance", with: @inventory_item.variance
    click_on "Update Inventory item"

    assert_text "Inventory item was successfully updated"
    click_on "Back"
  end

  test "destroying a Inventory item" do
    visit inventory_items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Inventory item was successfully destroyed"
  end
end
