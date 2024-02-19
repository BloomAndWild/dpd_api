require 'spec_helper'

describe DPDApi::Responses::StoreOrders do
  describe '#tracking_url' do
    it 'returns a tracking link with the correct format' do
      response = double(body: {
                          store_orders_response: {
                            order_result: {
                              shipment_responses: {
                                parcel_information: {
                                  parcel_label_number: "12345"
                                }
                              }
                            }
                          }
                        })

      result = described_class.new(response).tracking_url

      expect(result).to eq(
        "https://my.dpd.de/redirect.aspx?action=1&locale=en_US&parcelno=12345"
      )
    end
  end
end
