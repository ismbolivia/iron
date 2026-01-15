require 'test_helper'

class BoxUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @box_user = box_users(:one)
  end

  test "should get index" do
    get box_users_url
    assert_response :success
  end

  test "should get new" do
    get new_box_user_url
    assert_response :success
  end

  test "should create box_user" do
    assert_difference('BoxUser.count') do
      post box_users_url, params: { box_user: { acction: @box_user.acction, box_id: @box_user.box_id, user_id: @box_user.user_id } }
    end

    assert_redirected_to box_user_url(BoxUser.last)
  end

  test "should show box_user" do
    get box_user_url(@box_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_box_user_url(@box_user)
    assert_response :success
  end

  test "should update box_user" do
    patch box_user_url(@box_user), params: { box_user: { acction: @box_user.acction, box_id: @box_user.box_id, user_id: @box_user.user_id } }
    assert_redirected_to box_user_url(@box_user)
  end

  test "should destroy box_user" do
    assert_difference('BoxUser.count', -1) do
      delete box_user_url(@box_user)
    end

    assert_redirected_to box_users_url
  end
end
