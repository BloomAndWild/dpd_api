module DPDApi
  module Responses
    class BaseResponse
      attr_accessor :body

      def initialize response
        @response = response
        @body = response.body
      end

      def success?
        error.nil?
      end

      def error
        if instance_variable_defined?(:@error)
          @error
        else
          @error = request_error || data_error
        end
      end

      private

      def request_error
        if body.key?(:fault)
          fault = DPDApi::Responses::Fault.new(@response)
          DPDApi::DPDError.new(fault.message, status_code: fault.code, body: fault.body)
        end
      end

      def data_error
        nil
      end
    end
  end
end
