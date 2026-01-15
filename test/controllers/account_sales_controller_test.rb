require 'test_helper'

class AccountSalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account_sale = account_sales(:one)
  end

  test "should get index" do
    get account_sales_url
    assert_response :success
  end

  test "should get new" do
    get new_account_sale_url
    assert_response :success
  end

  test "should create account_sale" do
    assert_difference('AccountSale.count') do
      post account_sales_url, params: { account_sale: { account_id: @account_sale.account_id, amount: @account_sale.amount, sale_id: @account_sale.sale_id } }
    end

    assert_redirected_to account_sale_url(AccountSale.last)
  end

  test "should show account_sale" do
    get account_sale_url(@account_sale)
    assert_response :success
  end

  test "should get edit" do
    get edit_account_sale_url(@account_sale)
    assert_response :success
  end

  test "should update account_sale" do
    patch account_sale_url(@account_sale), params: { account_sale: { account_id: @account_sale.account_id, amount: @account_sale.amount, sale_id: @account_sale.sale_id } }
    assert_redirected_to account_sale_url(@account_sale)
  end

  test "should destroy account_sale" do
    assert_difference('AccountSale.count', -1) do
      delete account_sale_url(@account_sale)
    end

    assert_redirected_to account_sales_url
  end
end
