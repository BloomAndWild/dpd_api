module DPDApi
  class Config
    attr_writer :soap_endpoint, :service_wsdl, :logger
    attr_accessor :username, :password, :sandbox

    def service_wsdl
      @service_wsdl ||= {
        get_auth: File.join(DPDApi.root_path, 'lib', 'wsdl', 'LoginService_V2_0.wsdl'),
        store_orders: File.join(DPDApi.root_path, 'lib', 'wsdl', 'ShipmentService_V3_2.wsdl'),
      }
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def soap_endpoint
      @soap_endpoint ||= if sandbox
        {
          get_auth: "https://public-ws-stage.dpd.com/services/LoginService/V2_0/",
          store_orders: "https://public-ws-stage.dpd.com/services/ShipmentService/V3_2/",
        }
      else
        {
          get_auth: "https://public-ws-stage.dpd.com/services/LoginService/V2_0/",
          store_orders: "https://public-ws-stage.dpd.com/services/ShipmentService/V3_2/",
        }
      end
    end
  end
end
