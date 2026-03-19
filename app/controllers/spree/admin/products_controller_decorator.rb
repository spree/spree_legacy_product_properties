module Spree
  module Admin
    module ProductsControllerDecorator
      def self.prepended(base)
        base.new_action.before :build_product_properties
        base.edit_action.before :build_product_properties
      end

      private

      def build_product_properties
        return unless Spree::Config[:product_properties_enabled]

        Spree::Property.all.each do |property|
          @product.product_properties.build(property: property) unless @product.product_properties.find do |product_property|
            product_property.property_id == property.id
          end
        end
      end
    end
  end
end

if defined?(Spree::Admin::ProductsController)
  Spree::Admin::ProductsController.prepend(Spree::Admin::ProductsControllerDecorator)
end
