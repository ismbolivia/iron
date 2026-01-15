require 'test_helper'

class AddressesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @address = addresses(:one)
  end

  test "should get index" do
    get addresses_url
    assert_response :success
  end

  test "should get new" do
    get new_address_url
    assert_response :success
  end

  test "should create address" do
    assert_difference('Address.count') do
      post addresses_url, params: { address: { avenida_id: @address.avenida_id, calles: @address.calles, coordenadas: @address.coordenadas, country_id: @address.country_id, departamento_id: @address.departamento_id, description: @address.description, province_id: @address.province_id, zona_id: @address.zona_id } }
    end

    assert_redirected_to address_url(Address.last)
  end

  test "should show address" do
    get address_url(@address)
    assert_response :success
  end

  test "should get edit" do
    get edit_address_url(@address)
    assert_response :success
  end

  test "should update address" do
    patch address_url(@address), params: { address: { avenida_id: @address.avenida_id, calles: @address.calles, coordenadas: @address.coordenadas, country_id: @address.country_id, departamento_id: @address.departamento_id, description: @address.description, province_id: @address.province_id, zona_id: @address.zona_id } }
    assert_redirected_to address_url(@address)
  end

  test "should destroy address" do
    assert_difference('Address.count', -1) do
      delete address_url(@address)
    end

    assert_redirected_to addresses_url
  end
end
