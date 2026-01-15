require "application_system_test_case"

class AccountSalesTest < ApplicationSystemTestCase
  setup do
    @account_sale = account_sales(:one)
  end

  test "visiting the index" do
    visit account_sales_url
    assert_selector "h1", text: "Account Sales"
  end

  test "creating a Account sale" do
    visit account_sales_url
    click_on "New Account Sale"

    fill_in "Account", with: @account_sale.account_id
    fill_in "Amount", with: @account_sale.amount
    fill_in "Sale", with: @account_sale.sale_id
    click_on "Create Account sale"

    assert_text "Account sale was successfully created"
    click_on "Back"
  end

  test "updating a Account sale" do
    visit account_sales_url
    click_on "Edit", match: :first

    fill_in "Account", with: @account_sale.account_id
    fill_in "Amount", with: @account_sale.amount
    fill_in "Sale", with: @account_sale.sale_id
    click_on "Update Account sale"

    assert_text "Account sale was successfully updated"
    click_on "Back"
  end

  test "destroying a Account sale" do
    visit account_sales_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Account sale was successfully destroyed"
  end
end
