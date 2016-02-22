require 'test_helper'

class QuestionsTest < ActionDispatch::IntegrationTest
  test '만들어요' do
    sign_in(users(:one))

    post questions_path(question: { title: 'title', body: 'body' }, issue_title: issues(:issue1).title)

    assert assigns(:question).persisted?
    assert_equal 'title', assigns(:question).title
    assert_equal users(:one), assigns(:question).user
    assert_equal issues(:issue1).title, assigns(:question).issue.title
  end

  test '고쳐요' do
    sign_in(users(:one))

    put question_path(questions(:question1), question: { title: 'title x', body: 'body x' }, issue_title: issues(:issue2).title)

    assigns(:question).reload
    assert_equal 'title x', assigns(:question).title
    assert_equal users(:one), assigns(:question).user
    assert_equal issues(:issue2).title, assigns(:question).issue.title
  end

  test '세상에 없었던 새로운 이슈를 넣으면 저장이 안되요' do
    sign_in(users(:one))

    previous_count = Question.count
    post questions_path(question: { title: 'title', body: 'body' }, issue_title: '')
    assert_equal previous_count, Question.count
  end

  test '제목없는 이슈는 싫어요' do
    sign_in(users(:one))

    previous_count = Question.count
    post questions_path(question: { title: 'title', body: 'body' }, issue_title: '')
    assert_equal previous_count, Question.count
  end
end
