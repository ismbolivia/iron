require "application_system_test_case"

class AccountsTest < ApplicationSystemTestCase
  setup do
    @account = accounts(:one)
  end

  test "visiting the index" do
    visit accounts_url
    assert_selector "h1", text: "Accounts"
  end

  test "creating a Account" do
    visit accounts_url
    click_on "New Account"

    fill_in "Code", with: @account.code
    fill_in "Company", with: @account.company_id
    fill_in "Create Uid", with: @account.create_uid
    fill_in "Currency", with: @account.currency_id
    fill_in "Deprecated", with: @account.deprecated
    fill_in "Internal Type", with: @account.internal_type
    fill_in "Name", with: @account.name
    fill_in "Note", with: @account.note
    fill_in "Reconcile", with: @account.reconcile
    click_on "Create Account"

    assert_text "Account was successfully created"
    click_on "Back"
  end

  test "updating a Account" do
    visit accounts_url
    click_on "Edit", match: :first

    fill_in "Code", with: @account.code
    fill_in "Company", with: @account.company_id
    fill_in "Create Uid", with: @account.create_uid
    fill_in "Currency", with: @account.currency_id
    fill_in "Deprecated", with: @account.deprecated
    fill_in "Internal Type", with: @account.internal_type
    fill_in "Name", with: @account.name
    fill_in "Note", with: @account.note
    fill_in "Reconcile", with: @account.reconcile
    click_on "Update Account"

    assert_text "Account was successfully updated"
    click_on "Back"
  end

  test "destroying a Account" do
    visit accounts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Account was successfully destroyed"
  end
end
