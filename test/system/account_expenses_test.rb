require "application_system_test_case"

class AccountExpensesTest < ApplicationSystemTestCase
  setup do
    @account_expense = account_expenses(:one)
  end

  test "visiting the index" do
    visit account_expenses_url
    assert_selector "h1", text: "Account Expenses"
  end

  test "creating a Account expense" do
    visit account_expenses_url
    click_on "New Account Expense"

    fill_in "Account", with: @account_expense.account_id
    fill_in "Amount", with: @account_expense.amount
    fill_in "Description", with: @account_expense.description
    click_on "Create Account expense"

    assert_text "Account expense was successfully created"
    click_on "Back"
  end

  test "updating a Account expense" do
    visit account_expenses_url
    click_on "Edit", match: :first

    fill_in "Account", with: @account_expense.account_id
    fill_in "Amount", with: @account_expense.amount
    fill_in "Description", with: @account_expense.description
    click_on "Update Account expense"

    assert_text "Account expense was successfully updated"
    click_on "Back"
  end

  test "destroying a Account expense" do
    visit account_expenses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Account expense was successfully destroyed"
  end
end
