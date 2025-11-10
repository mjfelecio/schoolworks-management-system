require "test_helper"

class SchoolworksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get schoolworks_index_url
    assert_response :success
  end

  test "should get show" do
    get schoolworks_show_url
    assert_response :success
  end

  test "should get new" do
    get schoolworks_new_url
    assert_response :success
  end

  test "should get create" do
    get schoolworks_create_url
    assert_response :success
  end

  test "should get edit" do
    get schoolworks_edit_url
    assert_response :success
  end

  test "should get update" do
    get schoolworks_update_url
    assert_response :success
  end

  test "should get destroy" do
    get schoolworks_destroy_url
    assert_response :success
  end
end
