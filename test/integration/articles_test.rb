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

  test '제목을 body와 링크에서 만들어요' do
    sign_in(users(:one))

    post articles_path(article: { body: 'body' }, issue_title: issues(:issue1).title)
    assert_equal 'body', assigns(:article).title

    post articles_path(article: { body: 'title. body' }, issue_title: issues(:issue1).title)
    assert_equal 'title.', assigns(:article).title

    post articles_path(article: { body: "title\n body" }, issue_title: issues(:issue1).title)
    assert_equal 'title', assigns(:article).title

    post articles_path(article: { body: "title\n body", link: 'link' }, issue_title: issues(:issue1).title)
    assert_equal 'title', assigns(:article).title

    url = link_sources(:link1).url
    post articles_path(article: { body: "title\n body", link: url }, issue_title: issues(:issue1).title)
    assert_equal link_sources(:link1).title, assigns(:article).title

    url = "htt://new_link"
    post articles_path(article: { body: "title\n body", link: url }, issue_title: issues(:issue1).title)
    assert_equal 'title', assigns(:article).title
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
end
