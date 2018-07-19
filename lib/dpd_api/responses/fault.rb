module DPDApi
  module Responses
    class Fault
      attr_accessor :body

      def initialize(response)
        @body = response.body.fetch(:fault)
      end

      def code
        if detail.nil?
          body.fetch(:faultcode)
        else
          "#{key} - " + detail.dig(key, :error_code)
        end
      end

      def message
        if detail.nil?
          body.fetch(:faultstring)
        else
          detail.dig(key, :error_message)
        end
      end

      private

      def key
        detail.keys.first
      end

      def detail
        body[:detail]
      end
    end
  end
end
