module DPDApi
  module Requests
    class BaseRequest
      attr_accessor :attrs

      def initialize attrs
        @attrs = attrs
      end

      def xml_attributes
        attrs
      end
    end
  end
end
