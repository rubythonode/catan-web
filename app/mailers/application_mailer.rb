class ApplicationMailer < ActionMailer::Base
  helper 'parti_url'

  default from: "noreply@parti.xyz"
  layout 'email'
end
