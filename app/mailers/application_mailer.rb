class ApplicationMailer < ActionMailer::Base
  helper 'parti_url'

  default from: "feed@parti.xyz"
  layout 'email'
end
