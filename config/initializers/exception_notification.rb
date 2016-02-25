if Rails.env.production?
  Rails.application.config.middleware.use ExceptionNotification::Rack,
    :slack => {
      :webhook_url => "https://hooks.slack.com/services/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",
      :additional_parameters => {
        :mrkdwn => true
      }
    }
end
