module DPDApi
  module Responses
    class GetTrackingData < BaseResponse
      def shipment_info
        result.fetch(:shipment_info) { {} }
      end

      def status_info
        result.fetch(:status_info) { {} }
      end

      private

      def result
        body.dig(:get_tracking_data_response, :trackingresult) || {}
      end
    end
  end
end
