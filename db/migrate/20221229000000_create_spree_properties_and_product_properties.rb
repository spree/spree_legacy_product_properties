class CreateSpreePropertiesAndProductProperties < ActiveRecord::Migration[7.2]
  def change
    unless table_exists?(:spree_properties)
      create_table :spree_properties do |t|
        t.string :name, null: false
        t.string :presentation, null: false
        t.string :filter_param
        t.boolean :filterable, default: false, null: false
        t.string :kind, default: 'short_text'
        t.string :display_on, default: 'both'
        t.integer :position
        t.jsonb :metadata

        t.timestamps
      end

      add_index :spree_properties, :name, unique: true
    end

    unless table_exists?(:spree_product_properties)
      create_table :spree_product_properties do |t|
        t.string :value
        t.references :product, null: false
        t.references :property, null: false
        t.integer :position, default: 0
        t.string :filter_param
        t.boolean :show_property, default: true

        t.timestamps
      end

      add_index :spree_product_properties, [:property_id, :product_id], unique: true
    end

    unless table_exists?(:spree_property_prototypes)
      create_table :spree_property_prototypes do |t|
        t.references :prototype, null: false
        t.references :property, null: false
      end

      add_index :spree_property_prototypes, [:prototype_id, :property_id], unique: true
    end

    unless table_exists?(:spree_property_translations)
      create_table :spree_property_translations do |t|
        t.references :spree_property, null: false
        t.string :locale, null: false
        t.string :presentation

        t.timestamps
      end

      add_index :spree_property_translations, [:spree_property_id, :locale], unique: true, name: 'index_spree_property_translations_on_property_and_locale'
    end

    unless table_exists?(:spree_product_property_translations)
      create_table :spree_product_property_translations do |t|
        t.references :spree_product_property, null: false
        t.string :locale, null: false
        t.string :value
        t.string :filter_param

        t.timestamps
      end

      add_index :spree_product_property_translations, [:spree_product_property_id, :locale], unique: true, name: 'index_spree_pp_translations_on_pp_and_locale'
    end

    unless column_exists?(:spree_properties, :display_on)
      add_column :spree_properties, :display_on, :string, default: 'both'
    end

    unless column_exists?(:spree_properties, :position)
      add_column :spree_properties, :position, :integer
    end

    unless column_exists?(:spree_properties, :kind)
      add_column :spree_properties, :kind, :string, default: 'short_text'
    end
  end
end
