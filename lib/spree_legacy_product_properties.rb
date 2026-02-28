require 'spree'
require 'spree_legacy_product_properties/engine'
require 'spree_legacy_product_properties/version'
require 'spree_legacy_product_properties/configuration'

module SpreeLegacyProductProperties
  mattr_accessor :queue

  def self.queue
    @@queue ||= Spree.queues.default
  end
end
