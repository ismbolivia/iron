require "application_system_test_case"

class DevolutionsTest < ApplicationSystemTestCase
  setup do
    @devolution = devolutions(:one)
  end

  test "visiting the index" do
    visit devolutions_url
    assert_selector "h1", text: "Devolutions"
  end

  test "creating a Devolution" do
    visit devolutions_url
    click_on "New Devolution"

    fill_in "Mount", with: @devolution.mount
    fill_in "Obs", with: @devolution.obs
    fill_in "Qty", with: @devolution.qty
    fill_in "Sale detail", with: @devolution.sale_detail_id
    fill_in "Sale", with: @devolution.sale_id
    click_on "Create Devolution"

    assert_text "Devolution was successfully created"
    click_on "Back"
  end

  test "updating a Devolution" do
    visit devolutions_url
    click_on "Edit", match: :first

    fill_in "Mount", with: @devolution.mount
    fill_in "Obs", with: @devolution.obs
    fill_in "Qty", with: @devolution.qty
    fill_in "Sale detail", with: @devolution.sale_detail_id
    fill_in "Sale", with: @devolution.sale_id
    click_on "Update Devolution"

    assert_text "Devolution was successfully updated"
    click_on "Back"
  end

  test "destroying a Devolution" do
    visit devolutions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Devolution was successfully destroyed"
  end
end
