require 'test_helper'

class VotesTest < ActionDispatch::IntegrationTest
  test '만들어요' do
    sign_in users(:one)

    post opinion_votes_path(opinion_id: opinions(:opinion1).id, vote: { choice: :agree })

    assert assigns(:vote).persisted?
    assert_equal users(:one), assigns(:vote).user
    assert_equal 'agree', assigns(:vote).choice
  end

  test '같은 사람이 투표를 여러 번 해도 투표 건 수는 하나랍니다' do
    previous_count = opinions(:opinion1).votes.count
    assert opinions(:opinion1).voted_by? users(:two)

    sign_in users(:two)
    post opinion_votes_path(opinion_id: opinions(:opinion1).id, vote: { choice: :agree })

    assert_equal previous_count, opinions(:opinion1).votes.count
  end

  test '투표를 바꿔요' do
    assert opinions(:opinion1).agreed_by? users(:two)

    sign_in users(:two)
    post opinion_votes_path(opinion_id: opinions(:opinion1).id, vote: { choice: :disagree })

    refute opinions(:opinion1).reload.agreed_by? users(:two)
  end
end
