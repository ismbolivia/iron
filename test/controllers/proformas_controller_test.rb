require 'test_helper'

class ProformasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @proforma = proformas(:one)
  end

  test "should get index" do
    get proformas_url
    assert_response :success
  end

  test "should get new" do
    get new_proforma_url
    assert_response :success
  end

  test "should create proforma" do
    assert_difference('Proforma.count') do
      post proformas_url, params: { proforma: { number: @proforma.number, sale_id: @proforma.sale_id } }
    end

    assert_redirected_to proforma_url(Proforma.last)
  end

  test "should show proforma" do
    get proforma_url(@proforma)
    assert_response :success
  end

  test "should get edit" do
    get edit_proforma_url(@proforma)
    assert_response :success
  end

  test "should update proforma" do
    patch proforma_url(@proforma), params: { proforma: { number: @proforma.number, sale_id: @proforma.sale_id } }
    assert_redirected_to proforma_url(@proforma)
  end

  test "should destroy proforma" do
    assert_difference('Proforma.count', -1) do
      delete proforma_url(@proforma)
    end

    assert_redirected_to proformas_url
  end
end
