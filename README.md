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
  product: "CL",
  delivery_on: Date.parse("2018-06-06"),
  token: token,
  depot: "0160",
  customer_number: "1",
  weight: "100", # parcel weight in dag
  shipper_address: {
    name1: "",
    street_name: "",
    street_number: "",
    country: "DE",
    zip_code: "",
    city: "",
  },
  recipient_address: {
    name1: "",
    name2: "",
    street_name: "",
    street_number: "",
    country: "",
    zip_code: "",
    city: "",
    comment: "",
    phone: "",
    email: "",
  }
}

DPDApi::RequestHandler.request(:store_orders, attrs)
```

### Tracking:
```ruby
DPDApi::RequestHandler.request(:get_tracking_data, tracking_number: "123456789")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

