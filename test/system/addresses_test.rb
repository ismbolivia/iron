require "application_system_test_case"

class AddressesTest < ApplicationSystemTestCase
  setup do
    @address = addresses(:one)
  end

  test "visiting the index" do
    visit addresses_url
    assert_selector "h1", text: "Addresses"
  end

  test "creating a Address" do
    visit addresses_url
    click_on "New Address"

    fill_in "Avenida", with: @address.avenida_id
    fill_in "Calles", with: @address.calles
    fill_in "Coordenadas", with: @address.coordenadas
    fill_in "Country", with: @address.country_id
    fill_in "Departamento", with: @address.departamento_id
    fill_in "Description", with: @address.description
    fill_in "Province", with: @address.province_id
    fill_in "Zona", with: @address.zona_id
    click_on "Create Address"

    assert_text "Address was successfully created"
    click_on "Back"
  end

  test "updating a Address" do
    visit addresses_url
    click_on "Edit", match: :first

    fill_in "Avenida", with: @address.avenida_id
    fill_in "Calles", with: @address.calles
    fill_in "Coordenadas", with: @address.coordenadas
    fill_in "Country", with: @address.country_id
    fill_in "Departamento", with: @address.departamento_id
    fill_in "Description", with: @address.description
    fill_in "Province", with: @address.province_id
    fill_in "Zona", with: @address.zona_id
    click_on "Update Address"

    assert_text "Address was successfully updated"
    click_on "Back"
  end

  test "destroying a Address" do
    visit addresses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Address was successfully destroyed"
  end
end
