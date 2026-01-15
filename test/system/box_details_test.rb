require "application_system_test_case"

class BoxDetailsTest < ApplicationSystemTestCase
  setup do
    @box_detail = box_details(:one)
  end

  test "visiting the index" do
    visit box_details_url
    assert_selector "h1", text: "Box Details"
  end

  test "creating a Box detail" do
    visit box_details_url
    click_on "New Box Detail"

    fill_in "Amount", with: @box_detail.amount
    fill_in "Box", with: @box_detail.box_id
    fill_in "Payment", with: @box_detail.payment_id
    click_on "Create Box detail"

    assert_text "Box detail was successfully created"
    click_on "Back"
  end

  test "updating a Box detail" do
    visit box_details_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @box_detail.amount
    fill_in "Box", with: @box_detail.box_id
    fill_in "Payment", with: @box_detail.payment_id
    click_on "Update Box detail"

    assert_text "Box detail was successfully updated"
    click_on "Back"
  end

  test "destroying a Box detail" do
    visit box_details_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Box detail was successfully destroyed"
  end
end
