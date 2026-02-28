module SpreeLegacyProductProperties
  class BaseJob < Spree::BaseJob
    queue_as SpreeLegacyProductProperties.queue
  end
end
