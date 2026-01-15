require "application_system_test_case"

class BoxPurchaseOrderPaymentsTest < ApplicationSystemTestCase
  setup do
    @box_purchase_order_payment = box_purchase_order_payments(:one)
  end

  test "visiting the index" do
    visit box_purchase_order_payments_url
    assert_selector "h1", text: "Box Purchase Order Payments"
  end

  test "creating a Box purchase order payment" do
    visit box_purchase_order_payments_url
    click_on "New Box Purchase Order Payment"

    fill_in "Amount", with: @box_purchase_order_payment.amount
    fill_in "Box", with: @box_purchase_order_payment.box_id
    fill_in "Purchase order", with: @box_purchase_order_payment.purchase_order_id
    click_on "Create Box purchase order payment"

    assert_text "Box purchase order payment was successfully created"
    click_on "Back"
  end

  test "updating a Box purchase order payment" do
    visit box_purchase_order_payments_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @box_purchase_order_payment.amount
    fill_in "Box", with: @box_purchase_order_payment.box_id
    fill_in "Purchase order", with: @box_purchase_order_payment.purchase_order_id
    click_on "Update Box purchase order payment"

    assert_text "Box purchase order payment was successfully updated"
    click_on "Back"
  end

  test "destroying a Box purchase order payment" do
    visit box_purchase_order_payments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Box purchase order payment was successfully destroyed"
  end
end
