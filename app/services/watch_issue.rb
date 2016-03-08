class WatchIssue

  attr_accessor :issue
  attr_accessor :current_user

  def initialize(issue:, current_user:)
    @issue = issue
    @current_user = current_user
  end

  def call
    watch = self.issue.watches.build(user: self.current_user)
    watch.save
    watch
  end
end
