Rails.application.config.after_initialize do
  # Register permitted attributes
  Spree::PermittedAttributes.class_eval do
    @@product_properties_attributes = [:property_name, :property_id, :value, :position, :_destroy]
    @@property_attributes = [:name, :presentation, :position, :kind, :display_on]
  end

  # Register admin navigation
  if defined?(Spree::Admin)
    sidebar_nav = Spree.admin.navigation.sidebar

    products_nav = sidebar_nav.items.find { |item| item.key == :products }
    if products_nav
      products_nav.add :properties,
                       label: :properties,
                       url: :admin_properties_path,
                       position: 50,
                       if: -> { can?(:manage, Spree::Property) && Spree::Config.product_properties_enabled }
    end
  end
end
