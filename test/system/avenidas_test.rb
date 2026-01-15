require "application_system_test_case"

class AvenidasTest < ApplicationSystemTestCase
  setup do
    @avenida = avenidas(:one)
  end

  test "visiting the index" do
    visit avenidas_url
    assert_selector "h1", text: "Avenidas"
  end

  test "creating a Avenida" do
    visit avenidas_url
    click_on "New Avenida"

    fill_in "Name", with: @avenida.name
    click_on "Create Avenida"

    assert_text "Avenida was successfully created"
    click_on "Back"
  end

  test "updating a Avenida" do
    visit avenidas_url
    click_on "Edit", match: :first

    fill_in "Name", with: @avenida.name
    click_on "Update Avenida"

    assert_text "Avenida was successfully updated"
    click_on "Back"
  end

  test "destroying a Avenida" do
    visit avenidas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Avenida was successfully destroyed"
  end
end
