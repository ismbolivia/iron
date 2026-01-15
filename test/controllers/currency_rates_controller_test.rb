require 'test_helper'

class CurrencyRatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @currency_rate = currency_rates(:one)
  end

  test "should get index" do
    get currency_rates_url
    assert_response :success
  end

  test "should get new" do
    get new_currency_rate_url
    assert_response :success
  end

  test "should create currency_rate" do
    assert_difference('CurrencyRate.count') do
      post currency_rates_url, params: { currency_rate: { company_id: @currency_rate.company_id, create_uid: @currency_rate.create_uid, currency_id: @currency_rate.currency_id, currency_ref: @currency_rate.currency_ref, name: @currency_rate.name, rate: @currency_rate.rate, state: @currency_rate.state } }
    end

    assert_redirected_to currency_rate_url(CurrencyRate.last)
  end

  test "should show currency_rate" do
    get currency_rate_url(@currency_rate)
    assert_response :success
  end

  test "should get edit" do
    get edit_currency_rate_url(@currency_rate)
    assert_response :success
  end

  test "should update currency_rate" do
    patch currency_rate_url(@currency_rate), params: { currency_rate: { company_id: @currency_rate.company_id, create_uid: @currency_rate.create_uid, currency_id: @currency_rate.currency_id, currency_ref: @currency_rate.currency_ref, name: @currency_rate.name, rate: @currency_rate.rate, state: @currency_rate.state } }
    assert_redirected_to currency_rate_url(@currency_rate)
  end

  test "should destroy currency_rate" do
    assert_difference('CurrencyRate.count', -1) do
      delete currency_rate_url(@currency_rate)
    end

    assert_redirected_to currency_rates_url
  end
end
