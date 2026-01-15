require "application_system_test_case"

class UserModulosTest < ApplicationSystemTestCase
  setup do
    @user_modulo = user_modulos(:one)
  end

  test "visiting the index" do
    visit user_modulos_url
    assert_selector "h1", text: "User Modulos"
  end

  test "creating a User modulo" do
    visit user_modulos_url
    click_on "New User Modulo"

    fill_in "Modulo", with: @user_modulo.modulo_id
    fill_in "State", with: @user_modulo.state
    fill_in "User", with: @user_modulo.user_id
    click_on "Create User modulo"

    assert_text "User modulo was successfully created"
    click_on "Back"
  end

  test "updating a User modulo" do
    visit user_modulos_url
    click_on "Edit", match: :first

    fill_in "Modulo", with: @user_modulo.modulo_id
    fill_in "State", with: @user_modulo.state
    fill_in "User", with: @user_modulo.user_id
    click_on "Update User modulo"

    assert_text "User modulo was successfully updated"
    click_on "Back"
  end

  test "destroying a User modulo" do
    visit user_modulos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User modulo was successfully destroyed"
  end
end
