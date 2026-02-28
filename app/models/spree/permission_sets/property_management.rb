module Spree
  module PermissionSets
    class PropertyManagement < PermissionSets::Base
      def activate!
        can :manage, Spree::Property
        can :manage, Spree::ProductProperty
      end
    end
  end
end
