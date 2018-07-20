module DPDApi
  module Requests
    class StoreOrders < BaseRequest
      attr_accessor :attrs

      def initialize attrs
        @attrs = attrs
      end

      def xml_attributes
        attrs.fetch(:username)
        attrs.fetch(:token)

        attrs[:locale] ||= "en_EN"
        attrs[:file_format] ||= "PDF"
        attrs[:paper_format] ||= "A4"
        attrs[:sequence_number] ||= "1"
        attrs.fetch(:depot)
        attrs[:product] ||= "CL"
        attrs[:weight] ||= 10 # 10 = 1kg
        attrs[:complete_delivery] ||= 0

        attrs.fetch(:shipper_address)
        attrs[:shipper_address].fetch(:name1)
        attrs[:shipper_address].fetch(:street_name)
        attrs[:shipper_address].fetch(:street_number)
        attrs[:shipper_address].fetch(:zip_code)
        attrs[:shipper_address].fetch(:city)
        attrs[:shipper_address].fetch(:country)
        attrs[:shipper_address][:phone]
        attrs[:shipper_address][:email]
        attrs.fetch(:customer_number)

        attrs.fetch(:recipient_address)
        attrs[:recipient_address].fetch(:name1)
        attrs[:recipient_address][:name2]
        attrs[:recipient_address].fetch(:street_name)
        attrs[:recipient_address].fetch(:street_number)
        attrs[:recipient_address].fetch(:zip_code)
        attrs[:recipient_address].fetch(:city)
        attrs[:recipient_address].fetch(:country)
        attrs[:recipient_address][:phone]
        attrs[:recipient_address][:email]
        attrs[:recipient_address][:comment]

        # Possible values:
        # consignment
        # collection request order
        # pickup information
        attrs[:order_type] ||= "consignment"
        attrs.fetch(:delivery_on)
        attrs[:saturday_delivery] ||= attrs[:delivery_on].saturday? ? 1 : 0
        attrs[:date_from] ||= attrs[:delivery_on].strftime("%Y%m%d")

        # Channels:
        # 1 = email
        # 2 = telephone
        # 3 = SMS
        # 6 = FAX
        # 7 = postcard
        attrs[:notification_channel] ||= 1
        attrs[:notification_value] ||= attrs[:shipper_address][:email]

        # Bit flags:
        # 1 = pick-up
        # 2 = non-delivery
        # 4 = delivery
        # 8 = inbound
        # 16 = out for delivery
        attrs[:notification_rule] ||= 4
        attrs[:notification_locale] ||= "EN"
        attrs
      end
    end
  end
end
