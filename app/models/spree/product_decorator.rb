module Spree
  module ProductDecorator
    def self.prepended(base)
      base.has_many :product_properties, dependent: :destroy, inverse_of: :product
      base.has_many :properties, through: :product_properties

      base.accepts_nested_attributes_for :product_properties, allow_destroy: true, reject_if: lambda { |pp|
        pp[:property_id].blank? || (pp[:id].blank? && pp[:value].blank?)
      }

      base.whitelisted_ransackable_associations |= %w[properties]
    end

    def property(property_name)
      Spree::Deprecation.warn("Product properties are deprecated and will be removed in Spree 6.0. Please use Metafields instead")
      if product_properties.loaded?
        product_properties.detect { |property| property.property.name == property_name }.try(:value)
      else
        product_properties.joins(:property).find_by(spree_properties: { name: property_name }).try(:value)
      end
    end

    def set_property(property_name, property_value, property_presentation = property_name)
      Spree::Deprecation.warn("Product properties are deprecated and will be removed in Spree 6.0. Please use Metafields instead")
      property_name = property_name.to_s.parameterize
      ApplicationRecord.transaction do
        prop = if Spree::Property.where(name: property_name).exists?
                 existing_property = Spree::Property.where(name: property_name).first
                 existing_property.presentation ||= property_presentation
                 existing_property.save
                 existing_property
               else
                 Spree::Property.create(name: property_name, presentation: property_presentation)
               end

        product_property = if Spree::ProductProperty.where(product: self, property: prop).exists?
                             Spree::ProductProperty.where(product: self, property: prop).first
                           else
                             Spree::ProductProperty.new(product: self, property: prop)
                           end

        product_property.value = property_value
        product_property.save!
      end
    end

    def remove_property(property_name)
      Spree::Deprecation.warn("Product properties are deprecated and will be removed in Spree 6.0. Please use Metafields instead")
      product_properties.joins(:property).find_by(spree_properties: { name: property_name.parameterize })&.destroy
    end

    def storefront_description
      property('short_description') || description
    end

    private

    def add_associations_from_prototype
      if prototype_id && (prototype = Spree::Prototype.find_by(id: prototype_id))
        prototype.properties.each do |prop|
          product_properties.create(property: prop, value: 'Placeholder')
        end
        self.option_types = prototype.option_types
        self.taxons = prototype.taxons
      end
    end
  end
end

Spree::Product.prepend(Spree::ProductDecorator)
