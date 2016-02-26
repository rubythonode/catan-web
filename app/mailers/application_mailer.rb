class ApplicationMailer < ActionMailer::Base
  default from: "noreply@parti.xyz"
  layout 'email'
end
