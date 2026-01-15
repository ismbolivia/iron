require 'test_helper'

class BoxDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @box_detail = box_details(:one)
  end

  test "should get index" do
    get box_details_url
    assert_response :success
  end

  test "should get new" do
    get new_box_detail_url
    assert_response :success
  end

  test "should create box_detail" do
    assert_difference('BoxDetail.count') do
      post box_details_url, params: { box_detail: { amount: @box_detail.amount, box_id: @box_detail.box_id, payment_id: @box_detail.payment_id } }
    end

    assert_redirected_to box_detail_url(BoxDetail.last)
  end

  test "should show box_detail" do
    get box_detail_url(@box_detail)
    assert_response :success
  end

  test "should get edit" do
    get edit_box_detail_url(@box_detail)
    assert_response :success
  end

  test "should update box_detail" do
    patch box_detail_url(@box_detail), params: { box_detail: { amount: @box_detail.amount, box_id: @box_detail.box_id, payment_id: @box_detail.payment_id } }
    assert_redirected_to box_detail_url(@box_detail)
  end

  test "should destroy box_detail" do
    assert_difference('BoxDetail.count', -1) do
      delete box_detail_url(@box_detail)
    end

    assert_redirected_to box_details_url
  end
end
