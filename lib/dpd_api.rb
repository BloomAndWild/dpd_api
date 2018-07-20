require 'openssl'
require 'base64'
require 'savon'
require 'faraday'
require_relative "dpd_api/version"
require_relative "dpd_api/client"
require_relative "dpd_api/config"
require_relative "dpd_api/request_handler"
require_relative "dpd_api/xml_builder"
require_relative "dpd_api/xml_formatter"
require_relative "dpd_api/dpd_error"
require_relative "dpd_api/requests/base_request"
require_relative "dpd_api/requests/store_orders"
require_relative "dpd_api/responses/fault"
require_relative "dpd_api/responses/store_orders"
require_relative "dpd_api/responses/get_auth"
require_relative "dpd_api/responses/get_tracking_data"

module DPDApi
  def self.root_path
    File.dirname __dir__
  end
end
