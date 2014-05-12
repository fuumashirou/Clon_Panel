require 'test_helper'

class CheckinBillingsControllerTest < ActionController::TestCase
  test "should get discount" do
    get :discount
    assert_response :success
  end

  test "should get apply_discount" do
    get :apply_discount
    assert_response :success
  end

end
