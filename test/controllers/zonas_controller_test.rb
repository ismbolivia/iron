require 'test_helper'

class ZonasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @zona = zonas(:one)
  end

  test "should get index" do
    get zonas_url
    assert_response :success
  end

  test "should get new" do
    get new_zona_url
    assert_response :success
  end

  test "should create zona" do
    assert_difference('Zona.count') do
      post zonas_url, params: { zona: { name: @zona.name } }
    end

    assert_redirected_to zona_url(Zona.last)
  end

  test "should show zona" do
    get zona_url(@zona)
    assert_response :success
  end

  test "should get edit" do
    get edit_zona_url(@zona)
    assert_response :success
  end

  test "should update zona" do
    patch zona_url(@zona), params: { zona: { name: @zona.name } }
    assert_redirected_to zona_url(@zona)
  end

  test "should destroy zona" do
    assert_difference('Zona.count', -1) do
      delete zona_url(@zona)
    end

    assert_redirected_to zonas_url
  end
end
