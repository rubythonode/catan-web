require 'test_helper'

class IssuesTest < ActionDispatch::IntegrationTest
  test '만들어요' do
    sign_in(users(:admin))

    post issues_path(issue: { title: 'title', body: 'body' })

    assert assigns(:issue).persisted?
    assert_equal 'title', assigns(:issue).title
  end

  test '고쳐요' do
    sign_in(users(:admin))

    put issue_path(issues(:issue1), issue: { title: 'title x', body: 'body x' })

    assigns(:issue).reload
    assert_equal 'title x', assigns(:issue).title
  end

  test 'all이라는 이슈는 못만들어요' do
    sign_in(users(:admin))

    post issues_path(issue: { title: 'all', body: 'body' })

    refute assigns(:issue).persisted?
  end
end
