require "application_system_test_case"

class SaleDetailsTest < ApplicationSystemTestCase
  setup do
    @sale_detail = sale_details(:one)
  end

  test "visiting the index" do
    visit sale_details_url
    assert_selector "h1", text: "Sale Details"
  end

  test "creating a Sale detail" do
    visit sale_details_url
    click_on "New Sale Detail"

    fill_in "Item", with: @sale_detail.item_id
    fill_in "Number", with: @sale_detail.number
    fill_in "Price", with: @sale_detail.price
    fill_in "Qty", with: @sale_detail.qty
    fill_in "Sale", with: @sale_detail.sale_id
    click_on "Create Sale detail"

    assert_text "Sale detail was successfully created"
    click_on "Back"
  end

  test "updating a Sale detail" do
    visit sale_details_url
    click_on "Edit", match: :first

    fill_in "Item", with: @sale_detail.item_id
    fill_in "Number", with: @sale_detail.number
    fill_in "Price", with: @sale_detail.price
    fill_in "Qty", with: @sale_detail.qty
    fill_in "Sale", with: @sale_detail.sale_id
    click_on "Update Sale detail"

    assert_text "Sale detail was successfully updated"
    click_on "Back"
  end

  test "destroying a Sale detail" do
    visit sale_details_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sale detail was successfully destroyed"
  end
end
