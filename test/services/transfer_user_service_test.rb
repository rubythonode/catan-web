require 'test_helper'

class TransferUserServiceTest < ActiveSupport::TestCase
  focus
  test '소스 사용자의 글을 타켓 사용자의 글로 바꿉니다!' do
    source_user = users(:one)
    target_user = users(:two)

    source_posts_count = Post.where(user: source_user).count
    source_comments_count = Comment.where(user: source_user).count
    source_likes_count = Like.where(user: source_user).count
    source_votes_count = Vote.where(user: source_user).count
    source_watches_count = Watch.where(user: source_user).count

    target_posts_count = Post.where(user: target_user).count
    target_comments_count = Comment.where(user: target_user).count
    target_likes_count = Like.where(user: target_user).count
    target_votes_count = Vote.where(user: target_user).count
    target_watches_count = Watch.where(user: target_user).count

    estimated_likes_count = Like.where(user: [source_user, target_user]).pluck('DISTINCT post_id').count
    estimated_votes_count = Vote.where(user: [source_user, target_user]).pluck('DISTINCT post_id').count
    estimated_watches_count = Watch.where(user: [source_user, target_user]).pluck('DISTINCT issue_id').count

    TransferUserService.new(source_nickname: users(:one).nickname, target_nickname: users(:two).nickname).call

    final_posts_count = Post.where(user: target_user).count
    final_comments_count = Comment.where(user: target_user).count
    final_likes_count = Like.where(user: target_user).count
    final_votes_count = Vote.where(user: target_user).count
    final_watches_count = Watch.where(user: target_user).count

    assert_equal(final_posts_count, source_posts_count + target_posts_count)
    assert_equal(final_comments_count, source_comments_count + target_comments_count)

    assert_equal(estimated_likes_count, final_likes_count)
    assert_equal(estimated_votes_count, final_votes_count)
    assert_equal(estimated_watches_count, final_watches_count)

    refute User.exists?(nickname: users(:one).nickname)
  end
end
