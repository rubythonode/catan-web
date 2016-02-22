require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  test '뉴스컬럼에 만들어요' do
    sign_in(users(:one))

    post post_comments_path(post_id: articles(:article1).acting_as.id, comment: { body: 'body' })

    assert assigns(:comment).persisted?
    assert_equal 'body', assigns(:comment).body
    assert_equal users(:one), assigns(:comment).user
  end

  test '찬성하는 주장에 만들어요' do
    assert opinions(:opinion1).agreed_by? users(:two)

    sign_in(users(:two))

    post post_comments_path(post_id: opinions(:opinion1).acting_as.id, comment: { body: 'body' })

    assert assigns(:comment).persisted?
    assert_equal 'agree', assigns(:comment).choice
  end

  test '투표 안한 주장에 만들어요' do
    refute opinions(:opinion1).voted_by? users(:one)

    sign_in(users(:one))

    post post_comments_path(post_id: opinions(:opinion1).acting_as.id, comment: { body: 'body' })

    assert assigns(:comment).persisted?
    assert_nil assigns(:comment).choice
  end

  test '질문에 만들어요' do
    sign_in(users(:one))

    post post_comments_path(post_id: questions(:question1).acting_as.id, comment: { body: 'body' })

    assert assigns(:comment).persisted?
    assert_equal 'body', assigns(:comment).body
    assert_equal users(:one), assigns(:comment).user
  end

  test '답변에 만들어요' do
    sign_in(users(:one))

    post post_comments_path(post_id: answers(:answer1).acting_as.id, comment: { body: 'body' })

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
