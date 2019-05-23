require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'when credentials are set to ENV, encrypt the saved token and decrypt it through the getter' do
    ENV['ENCRYPTED_STRING_PASSWORD'] = 'passworrd'
    ENV['ENCRYPTED_STRING_SALT'] = '^]\x9E@\xB7eZ\xDD\xC0\xEC>$\a/\x1Cw'

    token = SecureRandom.base64
    user = User.create(token: token)
    encrypted_token = ActiveRecord::Base.connection.select_value('SELECT token FROM users')

    assert_equal token, user.token
    assert_not_equal token, encrypted_token

    ENV.delete 'ENCRYPTED_STRING_PASSWORD'
    ENV.delete 'ENCRYPTED_STRING_SALT'
  end

  test 'when credentials are set to config, encrypt the saved token and decrypt it through the getter' do
    ActiveRecord::Type::EncryptedString.encryption_password = 'passworrd'
    ActiveRecord::Type::EncryptedString.encryption_salt = 'salt'

    token = SecureRandom.base64
    user = User.create(token: token)
    encrypted_token = ActiveRecord::Base.connection.select_value('SELECT token FROM users')

    assert_equal token, user.token
    assert_not_equal token, encrypted_token
  end
end
