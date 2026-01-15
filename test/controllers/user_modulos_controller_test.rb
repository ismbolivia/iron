require 'test_helper'

class UserModulosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_modulo = user_modulos(:one)
  end

  test "should get index" do
    get user_modulos_url
    assert_response :success
  end

  test "should get new" do
    get new_user_modulo_url
    assert_response :success
  end

  test "should create user_modulo" do
    assert_difference('UserModulo.count') do
      post user_modulos_url, params: { user_modulo: { modulo_id: @user_modulo.modulo_id, state: @user_modulo.state, user_id: @user_modulo.user_id } }
    end

    assert_redirected_to user_modulo_url(UserModulo.last)
  end

  test "should show user_modulo" do
    get user_modulo_url(@user_modulo)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_modulo_url(@user_modulo)
    assert_response :success
  end

  test "should update user_modulo" do
    patch user_modulo_url(@user_modulo), params: { user_modulo: { modulo_id: @user_modulo.modulo_id, state: @user_modulo.state, user_id: @user_modulo.user_id } }
    assert_redirected_to user_modulo_url(@user_modulo)
  end

  test "should destroy user_modulo" do
    assert_difference('UserModulo.count', -1) do
      delete user_modulo_url(@user_modulo)
    end

    assert_redirected_to user_modulos_url
  end
end
