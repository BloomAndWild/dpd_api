module DPDApi
  module Responses
    class GetAuth < BaseResponse
      def token
        body.fetch(:get_auth_response).fetch(:return).fetch(:auth_token)
      end
    end
  end
end
