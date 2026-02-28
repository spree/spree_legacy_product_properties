pin 'application-spree-legacy-product-properties', to: 'spree_legacy_product_properties/application.js', preload: false

pin_all_from SpreeLegacyProductProperties::Engine.root.join('app/javascript/spree_legacy_product_properties/controllers'),
             under: 'spree_legacy_product_properties/controllers',
             to:    'spree_legacy_product_properties/controllers',
             preload: 'application-spree-legacy-product-properties'
