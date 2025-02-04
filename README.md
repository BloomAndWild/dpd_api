# DPDApi

[![Build Status](https://travis-ci.org/BloomAndWild/dpd_api.svg?branch=master)](https://travis-ci.org/BloomAndWild/dpd_api)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dpd'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dpd

## Usage

### Initializer:
```ruby
DPDApi::Client.configure do |config|
  config.username = ""
  config.password = ""
  config.sandbox = true
  # config.logger = Rails.logger
end
```

### Auth:
```ruby
token = DPDApi::RequestHandler.request(:get_auth).token
```

### New order:
```ruby
attrs = {
  product: "CL", # could be others such as E12, E18 etc
  delivery_on: Date.parse("2018-06-06"),
  token: token,
  username: username,
  locale: locale, # optional, the gem will default to en_EN
  file_format: "PDF", # optional, the gem defaults to PDF
  paper_format: "A4", # optional, the gem defaults to A4
  sequence_number: "1", # optional, the gem defaults to 1
  depot: "0160",
  complete_delivery: 0, # optional, the gem defaults to 0
  customer_number: "1", # optional, defaults to 1 for sandbox, or username for live
  weight: "100", # parcel weight in dag
  shipper_address: {
    name1: "",
    street_name: "",
    street_number: "",
    country: "DE",
    zip_code: "",
    city: "",
    email: "", # optional
    phone: "", # optional
  },
  recipient_address: {
    name1: "",
    name2: "", # optional
    street_name: "",
    street_number: "",
    country: "",
    zip_code: "",
    city: "",
    comment: "", # optional
    contact: "", # optional
    phone: "", # optional
    email: "", # optional
    customer_reference: "", # optional
    customer_reference_2: "", # optional
  }
  order_type: "consignment", # optional, defaults to consignment
  saturday_delivery: 0, # optional, defaults to 0
  add_service: 3, # optional, defaults to 3 (written permission to deposit goods by Sender)
  message_number: 14, # optional
  parcel_parameter: attrs[:recipient_address][:comment], # optional
  notification_channel: 1, # optional, defaults to 1 (values are 1: email, 2: telephone, 3: SMS, 6: FAX, 7: postcard)
  notification_value: attrs[:shipper_address][:email], # optional, defaults to the shipper email
  notification_locale: "EN", # optional, defaults to EN
  notification_rule: nil, # optional
  food: 0, # optional, defaults to 0
}

DPDApi::RequestHandler.request(:store_orders, attrs)
```

### Tracking:
```ruby
DPDApi::RequestHandler.request(:get_tracking_data, tracking_number: "123456789")
```

### Per request configuration
```ruby
DPDApi::RequestHandler.request(:get_auth) do |config|
  config.username = ""
  config.password = ""
  config.sandbox = true
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

