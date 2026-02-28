module SpreeLegacyProductProperties
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_legacy_product_properties'

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree_legacy_product_properties.environment', before: :load_config_initializers do |_app|
      SpreeLegacyProductProperties::Config = SpreeLegacyProductProperties::Configuration.new
    end

    initializer 'spree_legacy_product_properties.preferences', before: :load_config_initializers do
      Spree::AppConfiguration.preference :product_properties_enabled, :boolean, default: false
    end

    config.to_prepare do
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/models/spree/*_decorator*.rb')) do |c|
        require_dependency(c)
      end
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/models/spree/**/*_decorator*.rb')) do |c|
        require_dependency(c)
      end
    end

    initializer 'spree_legacy_product_properties.assets' do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.paths << root.join('app/javascript')
        app.config.assets.precompile += %w[spree_legacy_product_properties_manifest]
      end
    end

    initializer 'spree_legacy_product_properties.importmap', before: 'importmap' do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join('config/importmap.rb')
        app.config.importmap.cache_sweepers << root.join('app/javascript')
      end
    end
  end
end
