Rails.application.config.after_initialize do
  # Register product_properties_enabled preference if not already defined
  unless Spree::Config.respond_to?(:product_properties_enabled)
    Spree::Core::Configuration.preference :product_properties_enabled, :boolean, default: false
  end

  # Register permitted attributes for product properties
  unless Spree::PermittedAttributes::ATTRIBUTES.include?(:product_properties_attributes)
    Spree::PermittedAttributes::ATTRIBUTES.push(:product_properties_attributes, :property_attributes)

    Spree::PermittedAttributes.class_eval do
      mattr_accessor :product_properties_attributes
      mattr_accessor :property_attributes
    end

    Spree::PermittedAttributes.product_properties_attributes = [
      :property_name, :property_id, :value, :position, :_destroy
    ]
    Spree::PermittedAttributes.property_attributes = [
      :name, :presentation, :position, :kind, :display_on
    ]

    # Re-delegate the new attributes
    Spree::Core::ControllerHelpers::StrongParameters.delegate(
      :permitted_product_properties_attributes,
      :permitted_property_attributes,
      to: :permitted_attributes,
      prefix: false
    )
  end

  # Override permitted_product_attributes to include product_properties_attributes
  Spree::Core::ControllerHelpers::StrongParameters.module_eval do
    def permitted_product_attributes
      permitted_attributes.product_attributes + [
        variants_attributes: permitted_variant_attributes + ['id', :_destroy],
        master_attributes: permitted_variant_attributes + ['id'],
        product_properties_attributes: permitted_product_properties_attributes + ['id', :_destroy]
      ]
    end
  end

  # Register product form partial for properties
  if defined?(Spree::Admin) && Rails.application.config.respond_to?(:spree_admin)
    Rails.application.config.spree_admin.product_form_partials << 'spree/admin/products/form/properties'
  end

  # Register admin navigation
  if defined?(Spree::Admin) && Spree.respond_to?(:admin)
    sidebar_nav = Spree.admin.navigation.sidebar

    products_item = sidebar_nav.find(:products)
    if products_item
      builder = Spree::Admin::Navigation::Builder.new(sidebar_nav, products_item)
      builder.add :properties,
                  label: :properties,
                  url: :admin_properties_path,
                  position: 50,
                  if: -> { can?(:manage, Spree::Property) && Spree::Config.product_properties_enabled }
    end
  end
end
