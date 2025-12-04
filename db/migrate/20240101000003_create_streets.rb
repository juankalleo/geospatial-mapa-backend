class CreateStreets < ActiveRecord::Migration[7.1]
  def change
    create_table :streets do |t|
      t.string :name, null: false
      t.geometry :geom, null: false, srid: 4326, geographic: true
      t.jsonb :properties, default: {}

      t.timestamps
    end

    add_index :streets, :geom, using: :gist
    add_index :streets, :name
  end
end
