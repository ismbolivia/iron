require 'test_helper'

class TransferDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transfer_detail = transfer_details(:one)
  end

  test "should get index" do
    get transfer_details_url
    assert_response :success
  end

  test "should get new" do
    get new_transfer_detail_url
    assert_response :success
  end

  test "should create transfer_detail" do
    assert_difference('TransferDetail.count') do
      post transfer_details_url, params: { transfer_detail: { item_id: @transfer_detail.item_id, observation: @transfer_detail.observation, quantity: @transfer_detail.quantity, transfer_id: @transfer_detail.transfer_id } }
    end

    assert_redirected_to transfer_detail_url(TransferDetail.last)
  end

  test "should show transfer_detail" do
    get transfer_detail_url(@transfer_detail)
    assert_response :success
  end

  test "should get edit" do
    get edit_transfer_detail_url(@transfer_detail)
    assert_response :success
  end

  test "should update transfer_detail" do
    patch transfer_detail_url(@transfer_detail), params: { transfer_detail: { item_id: @transfer_detail.item_id, observation: @transfer_detail.observation, quantity: @transfer_detail.quantity, transfer_id: @transfer_detail.transfer_id } }
    assert_redirected_to transfer_detail_url(@transfer_detail)
  end

  test "should destroy transfer_detail" do
    assert_difference('TransferDetail.count', -1) do
      delete transfer_detail_url(@transfer_detail)
    end

    assert_redirected_to transfer_details_url
  end
end
