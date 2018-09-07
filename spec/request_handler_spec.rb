require "spec_helper"

describe DPDApi::RequestHandler do
  before do
    DPDApi::Client.configure do |config|
      config.username = ENV['DPD_USERNAME']
      config.password = ENV['DPD_PASSWORD']
      config.sandbox = true
      config.logger = Logger.new(STDOUT)
      config.logger.level = if ENV['LOGGER_LEVEL'].nil?
        1
      else
        ENV['LOGGER_LEVEL'].to_i
      end
    end
  end

  context "get_auth" do
    it "fetches auth token" do
      VCR.use_cassette('get_auth') do
        response = described_class.request(:get_auth)
        expect(response.token).to eq("LTI5MzMzODEyNzE4OTY4MzY1NTARMTUzMzc3OTUyMjU2MwRR")
      end
    end

    it "returns an error" do
      VCR.use_cassette('get_auth_error') do
        DPDApi::Client.configure do |config|
          config.username = "sandboxdpd"
          config.password = "wrongpassword"
          config.sandbox = true
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
        response = described_class.request(:get_auth)
        response = described_class.request(
          :store_orders,
          token: response.token,
          depot: "0998",
          sequence_number: 1,
          delivery_on: Date.parse("2018-08-14"),
          shipper_address: {
            name1: "Hans",
            street_name: "Burgerstr.",
            street_number: "123",
            country: "DE",
            zip_code: "10115",
            city: "Hamburger",
            email: "shipper@email.dev",
          },
          recipient_address: {
            name1: "Helga",
            street_name: "Currywurstr.",
            street_number: "123",
            contact: "2nd Floor Room 123",
            country: "DE",
            zip_code: "10115",
            city: "Currywurst",
            customer_reference: "Leave with receptionist",
            customer_reference_2: "",
          }
        )
        expect(response.shipment_responses).to include(
          identification_number: "1",
          mps_id: a_kind_of(String),
          parcel_information: { parcel_label_number: a_kind_of(String) }
        )
      end
    end
  end

  context "get_tracking_data" do
    it "fetches tracking data" do
      VCR.use_cassette('get_tracking_data') do
        response = described_class.request(
          :get_tracking_data,
          token: "LTI5MzMzODEyNzE4OTY4MzY1NTARMTUzMzc3OTUyMjU2MwRR",
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
          token: "LTI5MzMzODEyNzE4OTY4MzY1NTARMTUzMzc3OTUyMjU2MwRR",
          tracking_number: "00000000000000",
        )
        expect(response.shipment_info).to eq({})
      end
    end
  end
end
