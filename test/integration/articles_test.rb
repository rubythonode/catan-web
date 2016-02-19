require 'test_helper'

class ArticlesTest < ActionDispatch::IntegrationTest
  test '만들어요' do
    sign_in(users(:one))

    post articles_path(article: { title: 'title', body: 'body', link: 'link' }, issue_title: issues(:issue1).title)

    assert assigns(:article).persisted?
    assert_equal 'title', assigns(:article).title
    assert_equal users(:one), assigns(:article).user
    assert_equal issues(:issue1).title, assigns(:article).issue.title
  end

  test '고쳐요' do
    sign_in(users(:one))

    put article_path(articles(:article1), article: { title: 'title x', body: 'body x', link: 'link x' }, issue_title: issues(:issue2).title)

    assigns(:article).reload
    assert_equal 'title x', assigns(:article).title
    assert_equal users(:one), assigns(:article).user
    assert_equal issues(:issue2).title, assigns(:article).issue.title
  end

  test '세상에 없었던 새로운 이슈를 넣으면 저장이 안되요' do
    sign_in(users(:one))

    previous_count = Article.count
    post articles_path(article: { title: 'title', body: 'body', link: 'link' }, issue_title: '')
    assert_equal previous_count, Article.count
  end

  test '제목없는 이슈는 싫어요' do
    sign_in(users(:one))

    previous_count = Article.count
    post articles_path(article: { title: 'title', body: 'body' }, issue_title: '')
    assert_equal previous_count, Article.count
  end

  # test '마지막 수정 사항을 기록해요' do
  #   previous = assigns(:article).touched_at
  #   Timecop.freeze(Date.today + 30) do
  #     sign_in(users(:one))

  #     post articles_path(article: { title: 'title', body: 'body', link: 'link' }, issue_title: issues(:issue1).title)

  #     assert assigns(:article).persisted?
  #     refute_equal previous.to_s, assigns(:article).touched_at.to_s
  #     assert_equal 'create', assigns(:article).toched_last_action
  #     assert_equal assigns(:article), assigns(:article).touched_last_subject
  #   end
  # end
end
