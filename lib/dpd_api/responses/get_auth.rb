module DPDApi
  module Responses
    class GetAuth
      attr_accessor :body

      def initialize(response)
        @body = response.body.dig(:get_auth_response, :return)
      end

      def token
        @body.fetch(:auth_token)
      end
    end
  end
end
