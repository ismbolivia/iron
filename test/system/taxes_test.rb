require "application_system_test_case"

class TaxesTest < ApplicationSystemTestCase
  setup do
    @tax = taxes(:one)
  end

  test "visiting the index" do
    visit taxes_url
    assert_selector "h1", text: "Taxes"
  end

  test "creating a Tax" do
    visit taxes_url
    click_on "New Tax"

    fill_in "Account", with: @tax.account_id
    fill_in "Active", with: @tax.active
    fill_in "Amount", with: @tax.amount
    fill_in "Amount Type", with: @tax.amount_type
    fill_in "Analytic", with: @tax.analytic
    fill_in "Cash Basis Account", with: @tax.cash_basis_account
    fill_in "Company", with: @tax.company_id
    fill_in "Create Uid", with: @tax.create_uid
    fill_in "Description", with: @tax.description
    fill_in "Include Base Amount", with: @tax.include_base_amount
    fill_in "Name", with: @tax.name
    fill_in "Price Include", with: @tax.price_include
    fill_in "Refund Account", with: @tax.refund_account_id
    fill_in "Tax Adjustement", with: @tax.tax_adjustement
    fill_in "Tax Exigible", with: @tax.tax_exigible
    fill_in "Type Tax Use", with: @tax.type_tax_use
    fill_in "Write Uid", with: @tax.write_uid
    click_on "Create Tax"

    assert_text "Tax was successfully created"
    click_on "Back"
  end

  test "updating a Tax" do
    visit taxes_url
    click_on "Edit", match: :first

    fill_in "Account", with: @tax.account_id
    fill_in "Active", with: @tax.active
    fill_in "Amount", with: @tax.amount
    fill_in "Amount Type", with: @tax.amount_type
    fill_in "Analytic", with: @tax.analytic
    fill_in "Cash Basis Account", with: @tax.cash_basis_account
    fill_in "Company", with: @tax.company_id
    fill_in "Create Uid", with: @tax.create_uid
    fill_in "Description", with: @tax.description
    fill_in "Include Base Amount", with: @tax.include_base_amount
    fill_in "Name", with: @tax.name
    fill_in "Price Include", with: @tax.price_include
    fill_in "Refund Account", with: @tax.refund_account_id
    fill_in "Tax Adjustement", with: @tax.tax_adjustement
    fill_in "Tax Exigible", with: @tax.tax_exigible
    fill_in "Type Tax Use", with: @tax.type_tax_use
    fill_in "Write Uid", with: @tax.write_uid
    click_on "Update Tax"

    assert_text "Tax was successfully updated"
    click_on "Back"
  end

  test "destroying a Tax" do
    visit taxes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tax was successfully destroyed"
  end
end
