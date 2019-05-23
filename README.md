# ActiveRecord::Type::EncryptedString

[![Gem Version](https://badge.fury.io/rb/active_record-type-encrypted_string.svg)](https://badge.fury.io/rb/active_record-type-encrypted_string) [![Build Status](https://travis-ci.org/kymmt90/active_record-type-encrypted_string.svg?branch=master)](https://travis-ci.org/kymmt90/active_record-type-encrypted_string)

> Provides encrypted string attributes to Active Record models

ActiveRecord::Type::EncryptedString is a subtype of ActiveRecord::Type::String. This gem enables Active Record to encrypt/decrypt string attributes seamlessly.

## Usage

You can try this gem as follows:

```ruby
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'rails'
  gem 'active_record-type-encrypted_string'
  gem 'sqlite3'
end

require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:',
)

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :token
  end
end

# Define an string attribute
class User < ActiveRecord::Base
  attribute :token, :encrypted_string
end

# Settings for encryption
ENV['ENCRYPTED_STRING_PASSWORD'] = 'password'
ENV['ENCRYPTED_STRING_SALT'] = SecureRandom.random_bytes

# "token" is saved as encrypted string value
token = 'token'
user = User.create(token: token)
ActiveRecord::Base.connection.select_value('SELECT token FROM users') #=> "eVZzbUlXME1xSlZ5ZWZPQnIvY..."

# Get the encrypted value as a decrypted value transparently
user.token #=> "token"
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record-type-encrypted_string'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install active_record-type-encrypted_string
```

## Configuration

The password and the salt for encryption can be configured through environment variables or class attributes. Environment variables take precedence over class attributes.

```ruby
ENV['ENCRYPTED_STRING_PASSWORD'] = 'password'
ENV['ENCRYPTED_STRING_SALT'] = 'salt'


ActiveRecord::Type::EncryptedString.encryption_password = 'password'
ActiveRecord::Type::EncryptedString.encryption_salt = 'salt'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kymmt90/active_record-type-encrypted_string.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
