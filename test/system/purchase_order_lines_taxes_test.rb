require "application_system_test_case"

class PurchaseOrderLinesTaxesTest < ApplicationSystemTestCase
  setup do
    @purchase_order_lines_tax = purchase_order_lines_taxes(:one)
  end

  test "visiting the index" do
    visit purchase_order_lines_taxes_url
    assert_selector "h1", text: "Purchase Order Lines Taxes"
  end

  test "creating a Purchase order lines tax" do
    visit purchase_order_lines_taxes_url
    click_on "New Purchase Order Lines Tax"

    fill_in "Purchse Order Line", with: @purchase_order_lines_tax.purchse_order_line_id
    fill_in "Tax", with: @purchase_order_lines_tax.tax_id
    click_on "Create Purchase order lines tax"

    assert_text "Purchase order lines tax was successfully created"
    click_on "Back"
  end

  test "updating a Purchase order lines tax" do
    visit purchase_order_lines_taxes_url
    click_on "Edit", match: :first

    fill_in "Purchse Order Line", with: @purchase_order_lines_tax.purchse_order_line_id
    fill_in "Tax", with: @purchase_order_lines_tax.tax_id
    click_on "Update Purchase order lines tax"

    assert_text "Purchase order lines tax was successfully updated"
    click_on "Back"
  end

  test "destroying a Purchase order lines tax" do
    visit purchase_order_lines_taxes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Purchase order lines tax was successfully destroyed"
  end
end
