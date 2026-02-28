# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_legacy_product_properties/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_legacy_product_properties'
  s.version     = SpreeLegacyProductProperties::VERSION
  s.summary     = "Legacy Product Properties for Spree Commerce"
  s.description = "Legacy product properties system extracted from Spree core. Replaced by Metafields in Spree 5.x."
  s.required_ruby_version = '>= 3.2'

  s.author    = 'Vendo Connect Inc., Vendo Sp. z o.o.'
  s.email     = 'hello@spreecommerce.org'
  s.homepage  = 'https://github.com/spree/spree-legacy-product-properties'
  s.license   = 'MIT'

  s.files        = Dir["{app,config,db,lib,vendor}/**/*", "LICENSE.md", "Rakefile", "README.md"].reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  s.require_path = 'lib'
  s.requirements << 'none'

  spree_version = '>= 5.4.0.beta'
  s.add_dependency 'spree', spree_version
  s.add_dependency 'spree_admin', spree_version

  s.add_development_dependency 'spree_dev_tools'
end
