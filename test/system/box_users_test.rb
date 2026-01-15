require "application_system_test_case"

class BoxUsersTest < ApplicationSystemTestCase
  setup do
    @box_user = box_users(:one)
  end

  test "visiting the index" do
    visit box_users_url
    assert_selector "h1", text: "Box Users"
  end

  test "creating a Box user" do
    visit box_users_url
    click_on "New Box User"

    fill_in "Acction", with: @box_user.acction
    fill_in "Box", with: @box_user.box_id
    fill_in "User", with: @box_user.user_id
    click_on "Create Box user"

    assert_text "Box user was successfully created"
    click_on "Back"
  end

  test "updating a Box user" do
    visit box_users_url
    click_on "Edit", match: :first

    fill_in "Acction", with: @box_user.acction
    fill_in "Box", with: @box_user.box_id
    fill_in "User", with: @box_user.user_id
    click_on "Update Box user"

    assert_text "Box user was successfully updated"
    click_on "Back"
  end

  test "destroying a Box user" do
    visit box_users_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Box user was successfully destroyed"
  end
end
