require 'test_helper'

class UserTest < ActiveSupport::TestCase
  class WhenCredentialsAreSetToEnv < ActiveSupport::TestCase
    setup do
      ENV['ENCRYPTED_STRING_PASSWORD'] = 'passworrd'
      ENV['ENCRYPTED_STRING_SALT'] = '^]\x9E@\xB7eZ\xDD\xC0\xEC>$\a/\x1Cw'
    end

    teardown do
      ENV.delete 'ENCRYPTED_STRING_PASSWORD'
      ENV.delete 'ENCRYPTED_STRING_SALT'
    end

    test 'encrypt the saved token and decrypt it through the getter' do
      token = SecureRandom.base64
      user = User.create(token: token)
      encrypted_token = ActiveRecord::Base.connection.select_value('SELECT token FROM users')

      assert_equal token, user.token
      assert_not_equal token, encrypted_token
    end

    test 'should decrypt the saved token after the record was updated' do
      token = SecureRandom.base64
      user = User.create(token: token)
      user.update!(created_at: Time.now)
      encrypted_token = ActiveRecord::Base.connection.select_value('SELECT token FROM users')

      assert_equal token, user.token
      assert_not_equal token, encrypted_token
    end
  end

  class WhenCredentialsAreSetToConfig < ActiveSupport::TestCase
    setup do
      ActiveRecord::Type::EncryptedString.encryption_password = 'passworrd'
      ActiveRecord::Type::EncryptedString.encryption_salt = 'salt'
    end

    test 'encrypt the saved token and decrypt it through the getter' do
      token = SecureRandom.base64
      user = User.create(token: token)
      encrypted_token = ActiveRecord::Base.connection.select_value('SELECT token FROM users')

      assert_equal token, user.token
      assert_not_equal token, encrypted_token
    end
  end
end
