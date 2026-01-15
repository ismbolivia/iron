require 'test_helper'

class SettingCurrencyCompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @setting_currency_company = setting_currency_companies(:one)
  end

  test "should get index" do
    get setting_currency_companies_url
    assert_response :success
  end

  test "should get new" do
    get new_setting_currency_company_url
    assert_response :success
  end

  test "should create setting_currency_company" do
    assert_difference('SettingCurrencyCompany.count') do
      post setting_currency_companies_url, params: { setting_currency_company: { company_id: @setting_currency_company.company_id, currency_id: @setting_currency_company.currency_id } }
    end

    assert_redirected_to setting_currency_company_url(SettingCurrencyCompany.last)
  end

  test "should show setting_currency_company" do
    get setting_currency_company_url(@setting_currency_company)
    assert_response :success
  end

  test "should get edit" do
    get edit_setting_currency_company_url(@setting_currency_company)
    assert_response :success
  end

  test "should update setting_currency_company" do
    patch setting_currency_company_url(@setting_currency_company), params: { setting_currency_company: { company_id: @setting_currency_company.company_id, currency_id: @setting_currency_company.currency_id } }
    assert_redirected_to setting_currency_company_url(@setting_currency_company)
  end

  test "should destroy setting_currency_company" do
    assert_difference('SettingCurrencyCompany.count', -1) do
      delete setting_currency_company_url(@setting_currency_company)
    end

    assert_redirected_to setting_currency_companies_url
  end
end
