FactoryBot.define do
  factory :property, class: Spree::Property do
    sequence(:name) { |n| "baseball_cap_color_#{n}" }
    presentation { 'cap color' }

    trait :filterable do
      filterable { true }
    end

    trait :brand do
      name         { 'brand' }
      presentation { 'Brand' }
      filter_param { 'brand' }
    end

    trait :manufacturer do
      name         { 'manufacturer' }
      presentation { 'Manufacturer' }
      filter_param { 'manufacturer' }
    end

    trait :material do
      name         { 'material' }
      presentation { 'Material' }
      filter_param { 'material' }
    end
  end

  factory :product_property, class: Spree::ProductProperty do
    product
    value { "val-#{rand(50)}" }
    property
  end
end
