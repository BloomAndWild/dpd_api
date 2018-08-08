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

        expect(response.token).to eq("LTgwMTUyMjgwNzI4NzY0ODMwOTERMTUzMTk3OTQ0MTA0NwRR")
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
        response = described_class.request(
          :store_orders,
          token: "LTQ1MzQ2OTMyNjg3NDgwNjU5ODURMTUzMjA1NDUxOTM2MgRR",
          depot: "0998",
          sequence_number: 1,
          customer_number: 1,
          delivery_on: Date.parse("2018-07-25"),
          shipper_address: {
            name1: "Hans",
            street_name: "Burgerstr.",
            street_number: "123",
            country: "DE",
            zip_code: "10115",
            city: "Hamburger",
          },
          recipient_address: {
            name1: "Helga",
            street_name: "Currywurstr.",
            street_number: "123",
            country: "DE",
            zip_code: "10115",
            city: "Currywurst",
          }
        )
        expect(response.shipment_responses).to eq(
          identification_number: "1",
          mps_id: "MPS0998505261303620180720",
          parcel_information: { parcel_label_number: "09985052613036" }
        )
      end
    end
  end

  context "get_tracking_data" do
    it "fetches tracking data" do
      VCR.use_cassette('get_tracking_data') do
        response = described_class.request(
          :get_tracking_data,
          token: "LTQ1MzQ2OTMyNjg3NDgwNjU5ODURMTUzMjA1NDUxOTM2MgRR",
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
          token: "LTQ1MzQ2OTMyNjg3NDgwNjU5ODURMTUzMjA1NDUxOTM2MgRR",
          tracking_number: "00000000000000",
        )
        expect(response.shipment_info).to eq({})
      end
    end
  end
end
