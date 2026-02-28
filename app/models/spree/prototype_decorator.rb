module Spree
  module PrototypeDecorator
    def self.prepended(base)
      base.has_many :property_prototypes, class_name: 'Spree::PropertyPrototype'
      base.has_many :properties, through: :property_prototypes, class_name: 'Spree::Property'
    end
  end
end

Spree::Prototype.prepend(Spree::PrototypeDecorator)
