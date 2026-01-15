require 'test_helper'

class TaxesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tax = taxes(:one)
  end

  test "should get index" do
    get taxes_url
    assert_response :success
  end

  test "should get new" do
    get new_tax_url
    assert_response :success
  end

  test "should create tax" do
    assert_difference('Tax.count') do
      post taxes_url, params: { tax: { account_id: @tax.account_id, active: @tax.active, amount: @tax.amount, amount_type: @tax.amount_type, analytic: @tax.analytic, cash_basis_account: @tax.cash_basis_account, company_id: @tax.company_id, create_uid: @tax.create_uid, description: @tax.description, include_base_amount: @tax.include_base_amount, name: @tax.name, price_include: @tax.price_include, refund_account_id: @tax.refund_account_id, tax_adjustement: @tax.tax_adjustement, tax_exigible: @tax.tax_exigible, type_tax_use: @tax.type_tax_use, write_uid: @tax.write_uid } }
    end

    assert_redirected_to tax_url(Tax.last)
  end

  test "should show tax" do
    get tax_url(@tax)
    assert_response :success
  end

  test "should get edit" do
    get edit_tax_url(@tax)
    assert_response :success
  end

  test "should update tax" do
    patch tax_url(@tax), params: { tax: { account_id: @tax.account_id, active: @tax.active, amount: @tax.amount, amount_type: @tax.amount_type, analytic: @tax.analytic, cash_basis_account: @tax.cash_basis_account, company_id: @tax.company_id, create_uid: @tax.create_uid, description: @tax.description, include_base_amount: @tax.include_base_amount, name: @tax.name, price_include: @tax.price_include, refund_account_id: @tax.refund_account_id, tax_adjustement: @tax.tax_adjustement, tax_exigible: @tax.tax_exigible, type_tax_use: @tax.type_tax_use, write_uid: @tax.write_uid } }
    assert_redirected_to tax_url(@tax)
  end

  test "should destroy tax" do
    assert_difference('Tax.count', -1) do
      delete tax_url(@tax)
    end

    assert_redirected_to taxes_url
  end
end
