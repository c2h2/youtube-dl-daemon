require 'test_helper'

class VideosControllerTest < ActionController::TestCase
  setup do
    @video = videos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:videos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create video" do
    assert_difference('Video.count') do
      post :create, video: @video.attributes
    end

    assert_redirected_to video_path(assigns(:video))
  end

  test "should show video" do
    get :show, id: @video.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @video.to_param
    assert_response :success
  end

  test "should update video" do
    put :update, id: @video.to_param, video: @video.attributes
    assert_redirected_to video_path(assigns(:video))
  end

  test "should destroy video" do
    assert_difference('Video.count', -1) do
      delete :destroy, id: @video.to_param
    end

    assert_redirected_to videos_path
  end
end
