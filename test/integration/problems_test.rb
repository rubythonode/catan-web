require 'test_helper'

class ProblemsTest < ActionDispatch::IntegrationTest
  test '만들어요' do
    sign_in(users(:one))

    post problems_path(problem: { title: 'title', body: 'body' }, issue_title: issues(:issue1).title)

    assert assigns(:problem).persisted?
    assert_equal 'title', assigns(:problem).title
    assert_equal users(:one), assigns(:problem).user
    assert_equal issues(:issue1).title, assigns(:problem).issue.title
  end
  test '고쳐요' do
    sign_in(users(:one))

    put problem_path(problems(:problem1), problem: { title: 'title x', body: 'body x' }, issue_title: issues(:issue2).title)

    assigns(:problem).reload
    assert_equal 'title x', assigns(:problem).title
    assert_equal users(:one), assigns(:problem).user
    assert_equal issues(:issue2).title, assigns(:problem).issue.title
  end

  test '세상에 없었던 새로운 이슈를 넣으면 저장이 안되요' do
    sign_in(users(:one))

    previous_count = Question.count
    post problems_path(problem: { title: 'title', body: 'body' }, issue_title: '')
    assert_equal previous_count, Question.count
  end

  test '제목없는 이슈는 싫어요' do
    sign_in(users(:one))

    previous_count = Question.count
    post problems_path(problem: { title: 'title', body: 'body' }, issue_title: '')
    assert_equal previous_count, Question.count
  end
end
