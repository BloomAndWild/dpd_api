require "bundler/setup"

require "vcr"
require "pry"
require "dotenv"

require "dpd_api"

Dotenv.load

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

VCR.configure do |c|
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost                        = true
  c.cassette_library_dir                    = 'spec/support/fixtures/vcr_cassettes'
  c.allow_http_connections_when_no_cassette = true
  c.default_cassette_options                = {
    match_requests_on: [:uri],
    # record: :all,
  }

  c.filter_sensitive_data("<USERNAME>") { DPDApi::Client.config.username }
  c.filter_sensitive_data("<PASSWORD>") { DPDApi::Client.config.password }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
