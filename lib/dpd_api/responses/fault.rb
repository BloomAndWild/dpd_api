module DPDApi
  module Responses
    class Fault < BaseResponse
      def code
        if detail.nil?
          result.fetch(:faultcode)
        else
          "#{key} - " + detail.dig(key, :error_code)
        end
      end

      def message
        if detail.nil?
          result.fetch(:faultstring)
        else
          detail.dig(key, :error_message)
        end
      end

      private

      def key
        detail.keys.first
      end

      def detail
        result[:detail]
      end

      def result
        body.fetch(:fault)
      end
    end
  end
end
