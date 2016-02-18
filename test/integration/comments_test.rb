require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  test '만들어요' do
    sign_in(users(:one))

    post post_comments_path(post_id: articles(:article1).acting_as.id, comment: { body: 'body' })

    assert assigns(:comment).persisted?
    assert_equal 'body', assigns(:comment).body
    assert_equal users(:one), assigns(:comment).user
  end

  test '고쳐요' do
    sign_in(users(:one))

    put comment_path(comments(:comment1), comment: { body: 'body x' })

    assigns(:comment).reload
    assert_equal 'body x', assigns(:comment).body
  end
end
