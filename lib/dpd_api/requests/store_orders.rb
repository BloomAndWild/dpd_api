module DPDApi
  module Requests
    class StoreOrders < BaseRequest
      attr_accessor :attrs

      def initialize attrs
        @attrs = attrs
      end

      # TODO: Error messages
      def xml_attributes
        attrs.fetch(:username)
        attrs.fetch(:token)

        attrs[:locale] ||= "en_EN"
        attrs[:file_format] ||= "PDF"
        attrs[:paper_format] ||= "A4"
        attrs[:sequence_number] ||= "1"
        attrs.fetch(:depot)
        attrs[:product] ||= "CL"
        attrs[:weight] = (attrs[:weight] || 100).to_i # weight in dag (100dag = 1kg)
        attrs[:complete_delivery] ||= 0

        attrs.fetch(:shipper_address)
        attrs[:shipper_address].fetch(:name1)
        attrs[:shipper_address].fetch(:street_name)
        attrs[:shipper_address].fetch(:street_number)
        attrs[:shipper_address].fetch(:zip_code)
        attrs[:shipper_address].fetch(:city)
        attrs[:shipper_address].fetch(:country)
        attrs[:customer_number] ||=
          if Client.config.sandbox
            1
          else
            attrs.fetch(:account_number) || attrs.fetch(:username)
          end

        attrs.fetch(:recipient_address)
        attrs[:recipient_address].fetch(:name1)
        attrs[:recipient_address].fetch(:street_name)
        attrs[:recipient_address].fetch(:street_number)
        attrs[:recipient_address].fetch(:zip_code)
        attrs[:recipient_address].fetch(:city)
        attrs[:recipient_address].fetch(:country)

        # Possible values:
        # consignment
        # collection request order
        # pickup information
        attrs[:order_type] ||= "consignment"
        attrs[:saturday_delivery] ||= 0

        attrs[:add_service] ||= 3 # 3 = written permission to deposit goods by Sender
        attrs[:message_number] ||= 14
        attrs[:parcel_parameter] ||= attrs[:recipient_address][:comment]

        # Channels:
        # 1 = email
        # 2 = telephone
        # 3 = SMS
        # 6 = FAX
        # 7 = postcard
        attrs[:notification_channel] ||= 1
        attrs[:notification_value] ||= attrs[:shipper_address][:email]
        attrs[:notification_locale] ||= "EN"
        attrs[:food] ||= 0
        attrs
      end
    end
  end
end
