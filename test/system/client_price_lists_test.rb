require "application_system_test_case"

class ClientPriceListsTest < ApplicationSystemTestCase
  setup do
    @client_price_list = client_price_lists(:one)
  end

  test "visiting the index" do
    visit client_price_lists_url
    assert_selector "h1", text: "Client Price Lists"
  end

  test "creating a Client price list" do
    visit client_price_lists_url
    click_on "New Client Price List"

    fill_in "Client", with: @client_price_list.client_id
    fill_in "Price list", with: @client_price_list.price_list_id
    click_on "Create Client price list"

    assert_text "Client price list was successfully created"
    click_on "Back"
  end

  test "updating a Client price list" do
    visit client_price_lists_url
    click_on "Edit", match: :first

    fill_in "Client", with: @client_price_list.client_id
    fill_in "Price list", with: @client_price_list.price_list_id
    click_on "Update Client price list"

    assert_text "Client price list was successfully updated"
    click_on "Back"
  end

  test "destroying a Client price list" do
    visit client_price_lists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Client price list was successfully destroyed"
  end
end
