require 'test_helper'

class OpinionsTest < ActionDispatch::IntegrationTest
  test '만들어요' do
    sign_in(users(:one))

    post opinions_path(opinion: { title: 'title', body: 'body' }, issue_title: issues(:issue1).title)

    assert_equal 'title', assigns(:opinion).title
    assert_equal users(:one), assigns(:opinion).user
    assert_equal issues(:issue1).title, assigns(:opinion).issue.title
  end
  test '고쳐요' do
    sign_in(users(:one))

    put opinion_path(opinions(:opinion1), opinion: { title: 'title x', body: 'body x' }, issue_title: issues(:issue2).title)

    assert_equal 'title x', assigns(:opinion).title
    assert_equal users(:one), assigns(:opinion).user
    assert_equal issues(:issue2).title, assigns(:opinion).issue.title
  end
  test '세상에 없었던 새로운 이슈로 고쳐요' do
    sign_in(users(:one))

    put opinion_path(opinions(:opinion1), opinion: { title: 'title x', body: 'body x' }, issue_title: '세상에 없었던 이슈')

    assert_equal '세상에 없었던 이슈', assigns(:opinion).issue.title
  end
  test '제목없는 이슈는 싫어요' do
    sign_in(users(:one))

    previous_count = Issue.count
    post opinions_path(opinion: { title: 'title', body: 'body' }, issue_title: '')

    assert_equal previous_count, Issue.count
  end
end