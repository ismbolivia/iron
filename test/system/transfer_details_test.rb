require "application_system_test_case"

class TransferDetailsTest < ApplicationSystemTestCase
  setup do
    @transfer_detail = transfer_details(:one)
  end

  test "visiting the index" do
    visit transfer_details_url
    assert_selector "h1", text: "Transfer Details"
  end

  test "creating a Transfer detail" do
    visit transfer_details_url
    click_on "New Transfer Detail"

    fill_in "Item", with: @transfer_detail.item_id
    fill_in "Observation", with: @transfer_detail.observation
    fill_in "Quantity", with: @transfer_detail.quantity
    fill_in "Transfer", with: @transfer_detail.transfer_id
    click_on "Create Transfer detail"

    assert_text "Transfer detail was successfully created"
    click_on "Back"
  end

  test "updating a Transfer detail" do
    visit transfer_details_url
    click_on "Edit", match: :first

    fill_in "Item", with: @transfer_detail.item_id
    fill_in "Observation", with: @transfer_detail.observation
    fill_in "Quantity", with: @transfer_detail.quantity
    fill_in "Transfer", with: @transfer_detail.transfer_id
    click_on "Update Transfer detail"

    assert_text "Transfer detail was successfully updated"
    click_on "Back"
  end

  test "destroying a Transfer detail" do
    visit transfer_details_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Transfer detail was successfully destroyed"
  end
end
