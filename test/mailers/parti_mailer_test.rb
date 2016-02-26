require 'test_helper'

class PartiMailerTest < ActionMailer::TestCase
  focus
  test "summary" do
    # Send the email, then test that it got queued
    email = PartiMailer.summary(users(:recipient)).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['noreply@parti.xyz'], email.from
    assert_equal [users(:recipient).email], email.to
    assert_equal "#{Date.yesterday} Parti 유쾌한 민주주의 소식입니다!", email.subject
    byebug
    #assert_equal read_fixture('invite').join, email.text_part.body.to_s
  end
end
