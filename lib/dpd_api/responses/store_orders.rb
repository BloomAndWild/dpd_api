module DPDApi
  module Responses
    class StoreOrders
      attr_accessor :body

      def initialize(response)
        @body = response.body.dig(:store_orders_response, :order_result)
      end

      def pdf
        Base64.decode64(base64_pdf)
      end

      def tracking_number
        shipment_responses.dig(:parcel_information, :parcel_label_number)
      end

      def shipment_responses
        body.fetch(:shipment_responses)
      end

      def tracking_url
        "https://tracking.dpd.de/status/en_US/parcel/#{tracking_number}"
      end

      private

      def base64_pdf
        body.fetch(:parcellabels_pdf)
      end
    end
  end
end
