require "application_system_test_case"

class SuppliersTest < ApplicationSystemTestCase
  setup do
    @supplier = suppliers(:one)
  end

  test "visiting the index" do
    visit suppliers_url
    assert_selector "h1", text: "Suppliers"
  end

  test "creating a Supplier" do
    visit suppliers_url
    click_on "New Supplier"

    fill_in "Address", with: @supplier.address_id
    fill_in "Company", with: @supplier.company_id
    fill_in "Description", with: @supplier.description
    fill_in "Display Name", with: @supplier.display_name
    fill_in "Email", with: @supplier.email
    fill_in "Is Company", with: @supplier.is_company
    fill_in "Job", with: @supplier.job_id
    fill_in "Mobile", with: @supplier.mobile
    fill_in "Name", with: @supplier.name
    fill_in "Nit", with: @supplier.nit
    fill_in "Phone", with: @supplier.phone
    fill_in "Web Syte", with: @supplier.web_syte
    click_on "Create Supplier"

    assert_text "Supplier was successfully created"
    click_on "Back"
  end

  test "updating a Supplier" do
    visit suppliers_url
    click_on "Edit", match: :first

    fill_in "Address", with: @supplier.address_id
    fill_in "Company", with: @supplier.company_id
    fill_in "Description", with: @supplier.description
    fill_in "Display Name", with: @supplier.display_name
    fill_in "Email", with: @supplier.email
    fill_in "Is Company", with: @supplier.is_company
    fill_in "Job", with: @supplier.job_id
    fill_in "Mobile", with: @supplier.mobile
    fill_in "Name", with: @supplier.name
    fill_in "Nit", with: @supplier.nit
    fill_in "Phone", with: @supplier.phone
    fill_in "Web Syte", with: @supplier.web_syte
    click_on "Update Supplier"

    assert_text "Supplier was successfully updated"
    click_on "Back"
  end

  test "destroying a Supplier" do
    visit suppliers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Supplier was successfully destroyed"
  end
end
