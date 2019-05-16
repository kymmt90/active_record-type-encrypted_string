class User < ApplicationRecord
  attribute :token, :encrypted_string
end
