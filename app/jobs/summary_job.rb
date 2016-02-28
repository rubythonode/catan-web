class SummaryJob
  include Sidekiq::Worker

  def perform
    User.find_each do |user|
      summary(user)
    end
  end

  def summary(user)
    PartiMailer.summary(user).deliver_now
  rescue => e
    logger.error e.message
    e.backtrace.each { |line| logger.error line }
  end
end
