require "spec_helper"

describe DPDApi::RequestHandler do
  context "get_auth" do
    it "fetches auth token" do
      VCR.use_cassette('get_auth') do
        response = described_class.request(:get_auth)

        expect(response.body).to eq(
          delis_id: ENV["DPD_USERNAME"],
          customer_uid: ENV["DPD_USERNAME"],
          auth_token: "LTgwMTUyMjgwNzI4NzY0ODMwOTERMTUzMTk3OTQ0MTA0NwRR",
          depot: "0998",
        )
      end
    end

    it "returns an error" do
      VCR.use_cassette('get_auth_error') do
        DPDApi::Client.configure do |config|
          config.password = "wrongpassword"
        end

        expect {
          described_class.request(:get_auth)
        }.to raise_error(/The combination of user and password is invalid/)
      end
    end
  end

  context "store_orders" do
    it "creates an order" do
      VCR.use_cassette('store_orders') do
        response = described_class.request(
          :store_orders,
          token: "LTgwMTUyMjgwNzI4NzY0ODMwOTERMTUzMTk3OTQ0MTA0NwRR",
          depot: "0998",
          sequence_number: 1,
          customer_number: 1,
          shipper_address: {
            name1: "Hans",
            line1: "Burgerstr. 123",
            country: "DE",
            zip_code: "12312",
            city: "Hamburger",
          },
          recipient_address: {
            name1: "Helga",
            street_name: "Currywurstr. 123",
            state: "BY",
            country: "DE",
            zip_code: "12312",
            city: "Currywurst",
          }
        )
        expect(response.shipment_responses).to eq(
          identification_number: "1",
          mps_id: "MPS0998505261282720180719",
          parcel_information: { parcel_label_number: "09985052612827" }
        )
      end
    end
  end

  context "get_tracking_data" do
    it "fetches tracking data" do
      VCR.use_cassette('get_tracking_data') do
        response = described_class.request(
          :get_tracking_data,
          token: "LTgwMTUyMjgwNzI4NzY0ODMwOTERMTUzMTk3OTQ0MTA0NwRR",
          tracking_number: "09981122330100",
        )
        expect(response.shipment_info[:status]).to eq("SHIPMENT")
        expect(response.status_info.last[:status]).to eq("DELIVERED")
      end
    end

    it "fetches tracking data" do
      VCR.use_cassette('get_tracking_data_wrong_token') do
        expect {
          described_class.request(
            :get_tracking_data,
            token: "wrongtoken",
            tracking_number: "09981122330100",
          )
        }.to raise_error(/The authtoken is invalid/)
      end
    end

    it "returns nothing if number is wrong" do
      VCR.use_cassette('get_tracking_data_wrong_number') do
        response = described_class.request(
          :get_tracking_data,
          token: "LTgwMTUyMjgwNzI4NzY0ODMwOTERMTUzMTk3OTQ0MTA0NwRR",
          tracking_number: "00000000000000",
        )
        expect(response.shipment_info).to eq({})
      end
    end
  end
end
