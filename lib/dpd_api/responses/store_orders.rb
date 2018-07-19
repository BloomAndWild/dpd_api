module DPDApi
  module Responses
    class StoreOrders
      attr_accessor :body

      def initialize(response)
        @body = response.body.dig(:store_orders_response, :order_result)
      end

      def pdf
        body.fetch(:parcellabels_pdf)
      end

      def shipment_responses
        body.fetch(:shipment_responses)
      end

      def tracking_number
        shipment_responses.dig(:parcel_information, :parcel_label_number)
      end
    end
  end
end
