require 'active_record/type'
require 'active_record/type/encrypted_string/railtie'

module ActiveRecord
  module Type
    module EncryptedString
      class Type < ::ActiveRecord::Type::String
        def cast(value)
          value ? message_encryptor.encrypt_and_sign(value) : super
        end

        def deserialize(value)
          value ? message_encryptor.decrypt_and_verify(value) : super
        end

        private

        def message_encryptor
          @message_encryptor ||=
            begin
              key_len = ActiveSupport::MessageEncryptor.key_len
              key = ActiveSupport::KeyGenerator.new(password).generate_key(salt, key_len)
              ActiveSupport::MessageEncryptor.new(key)
            end
        end

        def password
          ENV['ENCRYPTED_STRING_PASSWORD']
        end

        def salt
          ENV['ENCRYPTED_STRING_SALT']
        end
      end
    end
  end
end

ActiveRecord::Type.register :encrypted_string, ActiveRecord::Type::EncryptedString::Type
