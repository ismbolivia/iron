require 'test_helper'

class AvenidasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @avenida = avenidas(:one)
  end

  test "should get index" do
    get avenidas_url
    assert_response :success
  end

  test "should get new" do
    get new_avenida_url
    assert_response :success
  end

  test "should create avenida" do
    assert_difference('Avenida.count') do
      post avenidas_url, params: { avenida: { name: @avenida.name } }
    end

    assert_redirected_to avenida_url(Avenida.last)
  end

  test "should show avenida" do
    get avenida_url(@avenida)
    assert_response :success
  end

  test "should get edit" do
    get edit_avenida_url(@avenida)
    assert_response :success
  end

  test "should update avenida" do
    patch avenida_url(@avenida), params: { avenida: { name: @avenida.name } }
    assert_redirected_to avenida_url(@avenida)
  end

  test "should destroy avenida" do
    assert_difference('Avenida.count', -1) do
      delete avenida_url(@avenida)
    end

    assert_redirected_to avenidas_url
  end
end
