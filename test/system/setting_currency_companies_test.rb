require "application_system_test_case"

class SettingCurrencyCompaniesTest < ApplicationSystemTestCase
  setup do
    @setting_currency_company = setting_currency_companies(:one)
  end

  test "visiting the index" do
    visit setting_currency_companies_url
    assert_selector "h1", text: "Setting Currency Companies"
  end

  test "creating a Setting currency company" do
    visit setting_currency_companies_url
    click_on "New Setting Currency Company"

    fill_in "Company", with: @setting_currency_company.company_id
    fill_in "Currency", with: @setting_currency_company.currency_id
    click_on "Create Setting currency company"

    assert_text "Setting currency company was successfully created"
    click_on "Back"
  end

  test "updating a Setting currency company" do
    visit setting_currency_companies_url
    click_on "Edit", match: :first

    fill_in "Company", with: @setting_currency_company.company_id
    fill_in "Currency", with: @setting_currency_company.currency_id
    click_on "Update Setting currency company"

    assert_text "Setting currency company was successfully updated"
    click_on "Back"
  end

  test "destroying a Setting currency company" do
    visit setting_currency_companies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Setting currency company was successfully destroyed"
  end
end
