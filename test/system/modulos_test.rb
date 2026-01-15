require "application_system_test_case"

class ModulosTest < ApplicationSystemTestCase
  setup do
    @modulo = modulos(:one)
  end

  test "visiting the index" do
    visit modulos_url
    assert_selector "h1", text: "Modulos"
  end

  test "creating a Modulo" do
    visit modulos_url
    click_on "New Modulo"

    fill_in "Active", with: @modulo.active
    fill_in "Color", with: @modulo.color
    fill_in "Icon", with: @modulo.icon
    fill_in "Installed", with: @modulo.installed
    fill_in "Name", with: @modulo.name
    fill_in "User", with: @modulo.user_id
    click_on "Create Modulo"

    assert_text "Modulo was successfully created"
    click_on "Back"
  end

  test "updating a Modulo" do
    visit modulos_url
    click_on "Edit", match: :first

    fill_in "Active", with: @modulo.active
    fill_in "Color", with: @modulo.color
    fill_in "Icon", with: @modulo.icon
    fill_in "Installed", with: @modulo.installed
    fill_in "Name", with: @modulo.name
    fill_in "User", with: @modulo.user_id
    click_on "Update Modulo"

    assert_text "Modulo was successfully updated"
    click_on "Back"
  end

  test "destroying a Modulo" do
    visit modulos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Modulo was successfully destroyed"
  end
end
