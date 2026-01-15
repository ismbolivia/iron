require "application_system_test_case"

class PriceListsTest < ApplicationSystemTestCase
  setup do
    @price_list = price_lists(:one)
  end

  test "visiting the index" do
    visit price_lists_url
    assert_selector "h1", text: "Price Lists"
  end

  test "creating a Price list" do
    visit price_lists_url
    click_on "New Price List"

    fill_in "Company", with: @price_list.company_id
    fill_in "Date", with: @price_list.date
    fill_in "Name", with: @price_list.name
    fill_in "State", with: @price_list.state
    fill_in "User Uid", with: @price_list.user_uid
    fill_in "Utilidad", with: @price_list.utilidad
    click_on "Create Price list"

    assert_text "Price list was successfully created"
    click_on "Back"
  end

  test "updating a Price list" do
    visit price_lists_url
    click_on "Edit", match: :first

    fill_in "Company", with: @price_list.company_id
    fill_in "Date", with: @price_list.date
    fill_in "Name", with: @price_list.name
    fill_in "State", with: @price_list.state
    fill_in "User Uid", with: @price_list.user_uid
    fill_in "Utilidad", with: @price_list.utilidad
    click_on "Update Price list"

    assert_text "Price list was successfully updated"
    click_on "Back"
  end

  test "destroying a Price list" do
    visit price_lists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Price list was successfully destroyed"
  end
end
