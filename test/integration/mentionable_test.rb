require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  test '멘션을 해요' do
    sign_in(users(:one))

    post post_comments_path(post_id: articles(:article1).acting_as.id, comment: { body: '@nick2 mention' })

    assert assigns(:comment).persisted?
    assert_equal users(:two), assigns(:comment).mentions.first.user
  end
end
