class CreateLandAreas < ActiveRecord::Migration[7.1]
  def change
    create_table :land_areas do |t|
      t.string :name, null: false
      t.string :area_type, null: false
      t.geometry :geom, null: false, srid: 4326
      t.jsonb :properties, default: {}

      t.timestamps
    end

    add_index :land_areas, :geom, using: :gist
    add_index :land_areas, :area_type
  end
end
