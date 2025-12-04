class CreateSavedFeatures < ActiveRecord::Migration[7.1]
  def change
    create_table :saved_features do |t|
      t.string :name, null: false
      t.text :description
      t.string :feature_type, null: false
      t.geometry :geom, null: false, srid: 4326
      t.jsonb :properties, default: {}

      t.timestamps
    end

    add_index :saved_features, :geom, using: :gist
    add_index :saved_features, :feature_type
    add_index :saved_features, :created_at
  end
end
