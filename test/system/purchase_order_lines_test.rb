require "application_system_test_case"

class PurchaseOrderLinesTest < ApplicationSystemTestCase
  setup do
    @purchase_order_line = purchase_order_lines(:one)
  end

  test "visiting the index" do
    visit purchase_order_lines_url
    assert_selector "h1", text: "Purchase Order Lines"
  end

  test "creating a Purchase order line" do
    visit purchase_order_lines_url
    click_on "New Purchase Order Line"

    fill_in "Company", with: @purchase_order_line.company_id
    fill_in "Date Planned", with: @purchase_order_line.date_planned
    fill_in "Item", with: @purchase_order_line.item_id
    fill_in "Item Qty", with: @purchase_order_line.item_qty
    fill_in "Name", with: @purchase_order_line.name
    fill_in "Price Tax", with: @purchase_order_line.price_tax
    fill_in "Price Unit", with: @purchase_order_line.price_unit
    fill_in "Purchase Order", with: @purchase_order_line.purchase_order
    fill_in "Purchase Order", with: @purchase_order_line.purchase_order_id
    fill_in "Qty Received", with: @purchase_order_line.qty_received
    fill_in "State", with: @purchase_order_line.state
    click_on "Create Purchase order line"

    assert_text "Purchase order line was successfully created"
    click_on "Back"
  end

  test "updating a Purchase order line" do
    visit purchase_order_lines_url
    click_on "Edit", match: :first

    fill_in "Company", with: @purchase_order_line.company_id
    fill_in "Date Planned", with: @purchase_order_line.date_planned
    fill_in "Item", with: @purchase_order_line.item_id
    fill_in "Item Qty", with: @purchase_order_line.item_qty
    fill_in "Name", with: @purchase_order_line.name
    fill_in "Price Tax", with: @purchase_order_line.price_tax
    fill_in "Price Unit", with: @purchase_order_line.price_unit
    fill_in "Purchase Order", with: @purchase_order_line.purchase_order
    fill_in "Purchase Order", with: @purchase_order_line.purchase_order_id
    fill_in "Qty Received", with: @purchase_order_line.qty_received
    fill_in "State", with: @purchase_order_line.state
    click_on "Update Purchase order line"

    assert_text "Purchase order line was successfully updated"
    click_on "Back"
  end

  test "destroying a Purchase order line" do
    visit purchase_order_lines_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Purchase order line was successfully destroyed"
  end
end
