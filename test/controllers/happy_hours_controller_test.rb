require 'test_helper'

class HappyHoursControllerTest < ActionController::TestCase
  setup do
    @happy_hour = happy_hours(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:happy_hours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create happy_hour" do
    assert_difference('HappyHour.count') do
      post :create, happy_hour: { active: @happy_hour.active, manual: @happy_hour.manual }
    end

    assert_redirected_to happy_hour_path(assigns(:happy_hour))
  end

  test "should show happy_hour" do
    get :show, id: @happy_hour
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @happy_hour
    assert_response :success
  end

  test "should update happy_hour" do
    patch :update, id: @happy_hour, happy_hour: { active: @happy_hour.active, manual: @happy_hour.manual }
    assert_redirected_to happy_hour_path(assigns(:happy_hour))
  end

  test "should destroy happy_hour" do
    assert_difference('HappyHour.count', -1) do
      delete :destroy, id: @happy_hour
    end

    assert_redirected_to happy_hours_path
  end
end
