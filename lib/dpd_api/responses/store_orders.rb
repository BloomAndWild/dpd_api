module DPDApi
  module Responses
    class StoreOrders < BaseResponse
      def pdf
        Base64.decode64(base64_pdf)
      end

      def tracking_url
        "https://tracking.dpd.de/status/en_US/parcel/#{tracking_number}"
      end

      def tracking_number
        shipment_responses.dig(:parcel_information, :parcel_label_number)
      end

      def shipment_responses
        result.fetch(:shipment_responses)
      end

      private

      def data_error
        if shipment_responses.key?(:faults)
          code = shipment_responses[:faults].fetch(:fault_code)
          message = shipment_responses[:faults].fetch(:message)
          DPDApi::DPDError.new(message, status_code: code)
        end
      end

      def base64_pdf
        result.fetch(:parcellabels_pdf)
      end

      def result
        body.dig(:store_orders_response, :order_result)
      end
    end
  end
end
