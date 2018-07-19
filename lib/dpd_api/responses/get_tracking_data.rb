module DPDApi
  module Responses
    class GetTrackingData
      attr_accessor :body

      def initialize(response)
        @body = response.body.dig(:get_tracking_data_response, :trackingresult)
      end

      def shipment_info
        body.fetch(:shipment_info)
      end

      def status_info
        body.fetch(:status_info)
      end
    end
  end
end
