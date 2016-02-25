require 'test_helper'

class OpinionsTest < ActionDispatch::IntegrationTest
  test '만들어요' do
    sign_in(users(:one))

    post opinions_path(opinion: { title: 'title' }, issue_title: issues(:issue1).title, comment_body: 'body')

    assert assigns(:opinion).persisted?

    assert_equal 'title', assigns(:opinion).title
    assert_equal users(:one), assigns(:opinion).user
    assert_equal issues(:issue1).title, assigns(:opinion).issue.title

    assert assigns(:vote).persisted?
    assert_equal 'agree', assigns(:vote).choice
    assert_equal users(:one), assigns(:vote).user

    assert assigns(:comment).persisted?
    assert_equal 'body', assigns(:comment).body
    assert_equal users(:one), assigns(:comment).user
  end

  test '고쳐요' do
    sign_in(users(:one))

    put opinion_path(opinions(:opinion1), opinion: { title: 'title x' }, issue_title: issues(:issue2).title)

    assigns(:opinion).reload
    assert_equal 'title x', assigns(:opinion).title
    assert_equal users(:one), assigns(:opinion).user
    assert_equal issues(:issue2).title, assigns(:opinion).issue.title
  end

  test '세상에 없었던 새로운 이슈를 넣으면 저장이 안되요' do
    sign_in(users(:one))

    previous_count = Opinion.count
    post opinions_path(opinion: { title: 'title' }, issue_title: '세상에 없었던 이슈')
    assert_equal previous_count, Opinion.count
  end

  test '제목없는 이슈는 싫어요' do
    sign_in(users(:one))

    previous_count = Opinion.count
    post opinions_path(opinion: { title: 'title' }, issue_title: '')

    assert_equal previous_count, Opinion.count
  end
end
