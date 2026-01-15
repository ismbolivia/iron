require "application_system_test_case"

class PaymentTermsTest < ApplicationSystemTestCase
  setup do
    @payment_term = payment_terms(:one)
  end

  test "visiting the index" do
    visit payment_terms_url
    assert_selector "h1", text: "Payment Terms"
  end

  test "creating a Payment term" do
    visit payment_terms_url
    click_on "New Payment Term"

    fill_in "Active", with: @payment_term.active
    fill_in "Company", with: @payment_term.company_id
    fill_in "Create Uid", with: @payment_term.create_uid
    fill_in "Name", with: @payment_term.name
    fill_in "Note", with: @payment_term.note
    click_on "Create Payment term"

    assert_text "Payment term was successfully created"
    click_on "Back"
  end

  test "updating a Payment term" do
    visit payment_terms_url
    click_on "Edit", match: :first

    fill_in "Active", with: @payment_term.active
    fill_in "Company", with: @payment_term.company_id
    fill_in "Create Uid", with: @payment_term.create_uid
    fill_in "Name", with: @payment_term.name
    fill_in "Note", with: @payment_term.note
    click_on "Update Payment term"

    assert_text "Payment term was successfully updated"
    click_on "Back"
  end

  test "destroying a Payment term" do
    visit payment_terms_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Payment term was successfully destroyed"
  end
end
