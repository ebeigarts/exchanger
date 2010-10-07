module Exchanger
  # SOAP Client for Exhange Web Services
  class Client
    delegate :endpoint, :timeout, :username, :password, :debug, :to => "Exchanger.config"

    def initialize
      @client = HTTPClient.new
      @client.debug_dev = STDERR if debug
      @client.set_auth nil, username, password if username
    end

    # Does the actual HTTP level interaction.
    def request(post_body, headers)
      # @client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = @client.post(endpoint, post_body, headers)
      return { :status => response.status, :body => response.content, :content_type => response.contenttype }
    end
  end
end
