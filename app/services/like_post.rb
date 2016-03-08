class LikePost

  attr_accessor :post
  attr_accessor :current_user

  def initialize(post:, current_user:)
    @post = post
    @current_user = current_user
  end

  def call
    like = self.post.likes.build(user: self.current_user)
    like.save
    like
  end
end
