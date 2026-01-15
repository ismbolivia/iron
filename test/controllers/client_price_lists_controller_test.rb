require 'test_helper'

class ClientPriceListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client_price_list = client_price_lists(:one)
  end

  test "should get index" do
    get client_price_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_client_price_list_url
    assert_response :success
  end

  test "should create client_price_list" do
    assert_difference('ClientPriceList.count') do
      post client_price_lists_url, params: { client_price_list: { client_id: @client_price_list.client_id, price_list_id: @client_price_list.price_list_id } }
    end

    assert_redirected_to client_price_list_url(ClientPriceList.last)
  end

  test "should show client_price_list" do
    get client_price_list_url(@client_price_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_client_price_list_url(@client_price_list)
    assert_response :success
  end

  test "should update client_price_list" do
    patch client_price_list_url(@client_price_list), params: { client_price_list: { client_id: @client_price_list.client_id, price_list_id: @client_price_list.price_list_id } }
    assert_redirected_to client_price_list_url(@client_price_list)
  end

  test "should destroy client_price_list" do
    assert_difference('ClientPriceList.count', -1) do
      delete client_price_list_url(@client_price_list)
    end

    assert_redirected_to client_price_lists_url
  end
end
