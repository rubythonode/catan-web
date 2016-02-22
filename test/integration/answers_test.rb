require 'test_helper'

class AnswersTest < ActionDispatch::IntegrationTest
  test '만들어요' do
    sign_in(users(:two))

    post question_answers_path(question_id: questions(:question1).id,
      answer: { body: 'body' })

    assert assigns(:answer).persisted?
    assert_equal 'body', assigns(:answer).body
    assert_equal users(:two), assigns(:answer).user
    assert_equal issues(:issue1).title, questions(:question1).issue.title
  end

  test '고쳐요' do
    sign_in(users(:two))

    put answer_path(answers(:answer1), answer: { body: 'body x' })

    assigns(:answer).reload
    assert_equal 'body x', assigns(:answer).body
    assert_equal users(:two), assigns(:answer).user
    assert_equal answers(:answer1).question.issue.title, assigns(:answer).issue.title
  end
end
