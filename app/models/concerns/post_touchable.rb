module PostTouchable
  extend ActiveSupport::Concern

  def touch_post_by_vote
    if (post.votes_count % 3 == 0) and !too_fast?
      touch_post(:vote, post.votes_count)
    end
  end

  def touch_post_by_comment
    if (post.comments_count % 3 == 0) and !too_fast?
      touch_post(:comment, post.comments_count)
    end
  end

  def touch_post_by_like
    if (post.likes_count % 3 == 0) and !too_fast?
      touch_post(:like, post.likes_count)
    end
  end

  private

  def too_fast?
    TimeDifference.between(post.touched_at, DateTime.now).in_hours.abs <= 1
  end

  def touch_post(action, params)
    return if(post.last_touched_action == action and
              post.last_touched_params == params)

    post.touched_at = DateTime.now
    post.save
  end
end
