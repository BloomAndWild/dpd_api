module DPDApi
  class RequestHandler
    class << self
      def request(request_name, attrs = {}, &block)
        new(request_name, attrs).run(&block)
      end
    end

    def initialize(request_name, attrs)
      @request_name = request_name.to_sym
      @attrs = attrs
      @config = Client.config.dup
    end

    def run
      yield config if block_given?
      response = parse_response(get_response)
      if response.success?
        response
      else
        raise response.error
      end
    end

    def client
      Savon.client(
        adapter: config.adapter || :httpclient,
        wsdl: config.service_wsdl[request_name],
        endpoint: config.soap_endpoint[request_name],
        namespace: config.soap_endpoint[request_name],
        open_timeout: 600,
        read_timeout: 600,
        logger: config.logger,
        log_level: config.logger.level.zero? ? :debug : :info,
        log: config.logger.level.zero?,
        pretty_print_xml: true,
        follow_redirects: true,
        raise_errors: false,
      )
    end

    private
    attr_accessor :request_name, :attrs, :config

    def get_response
      xml = xml_builder(request.xml_attributes).build
      client.call(request_name, xml: xml)
    end

    def request
      case request_name
      when :store_orders
        DPDApi::Requests::StoreOrders.new(attrs.merge(security_attrs))
      else
        DPDApi::Requests::BaseRequest.new(attrs.merge(security_attrs))
      end
    end

    def xml_builder attrs = {}
      DPDApi::XMLBuilder.new(request_name, attrs)
    end

    def parse_response raw_response
      response(raw_response)
    rescue => ex
      raise DPDApi::DPDError.new(ex.message, body: raw_response.body)
    end

    def response raw_response
      case request_name
      when :get_auth
        DPDApi::Responses::GetAuth.new(raw_response)
      when :store_orders
        DPDApi::Responses::StoreOrders.new(raw_response)
      when :get_tracking_data
        DPDApi::Responses::GetTrackingData.new(raw_response)
      end
    end

    def security_attrs
      {
        username: config.username,
        password: config.password,
      }
    end
  end
end
