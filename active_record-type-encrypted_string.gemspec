$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "active_record/type/encrypted_string/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "active_record-type-encrypted_string"
  spec.version     = ActiveRecord::Type::EncryptedString::VERSION
  spec.authors     = ["Kohei Yamamoto"]
  spec.email       = ["kymmt90@gmail.com"]
  spec.homepage    = "https://github.com/kymmt90/active_record-type-encrypted_string"
  spec.summary     = "ActiveRecord::Type::EncryptedString"
  spec.description = "Provides encrypted string attributes to Active Record models"
  spec.license     = "MIT"
  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.0"

  spec.add_development_dependency "sqlite3"
end
