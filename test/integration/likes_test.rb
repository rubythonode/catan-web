require 'test_helper'

class LikesTest < ActionDispatch::IntegrationTest
  test '뉴스컬럼을 좋아해요' do
    sign_in(users(:one))

    post post_likes_path(post_id: articles(:article1).acting_as.id), format: :js

    assert assigns(:like).persisted?
    assert_equal users(:one), assigns(:like).user
  end

  test '뉴스컬럼 좋아요를 취소해요' do
    assert articles(:article1).liked_by?(users(:two))

    sign_in(users(:two))

    delete cancel_post_likes_path(post_id: articles(:article1).acting_as.id), format: :js

    refute articles(:article1).liked_by?(users(:two))
  end
end
