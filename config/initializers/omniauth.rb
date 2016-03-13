module OmniAuth::Strategies

  class FacebookTransfer < Facebook
    def name
      :facebook_transfer
    end
  end

  class GoogleOauth2Transfer < GoogleOauth2
    def name
      :google_oauth2_transfer
    end
  end

end
