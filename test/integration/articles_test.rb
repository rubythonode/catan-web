require 'test_helper'

class ArticlesTest < ActionDispatch::IntegrationTest
  test '만들어요' do
    sign_in(users(:one))

    post articles_path(article: { title: 'title', body: 'body', link: 'link', issue_id: issues(:issue1).id })

    assert_equal 'title', assigns(:article).title
    assert_equal users(:one), assigns(:article).user
    assert_equal issues(:issue1).title, assigns(:article).issue.title
  end

  test '고쳐요' do
    sign_in(users(:one))

    put article_path(articles(:article1), article: { title: 'title x', body: 'body x', link: 'link x', issue_id: issues(:issue2).id })

    assert_equal 'title x', assigns(:article).title
    assert_equal users(:one), assigns(:article).user
    assert_equal issues(:issue2).title, assigns(:article).issue.title
  end

  test '세상에 없었던 새로운 이슈를 넣으면 저장이 안되요' do
    sign_in(users(:one))

    previous_count = Article.count
    post articles_path(article: { title: 'title', body: 'body', link: 'link', issue_id: '' })
    assert_equal previous_count, Article.count
  end

end