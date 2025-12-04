# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_01_000004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "land_areas", force: :cascade do |t|
    t.string "name", null: false
    t.string "area_type", null: false
    t.geometry "geom", limit: {:srid=>4326, :type=>"geometry"}, null: false
    t.jsonb "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_type"], name: "index_land_areas_on_area_type"
    t.index ["geom"], name: "index_land_areas_on_geom", using: :gist
  end

  create_table "saved_features", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "feature_type", null: false
    t.geometry "geom", limit: {:srid=>4326, :type=>"geometry"}, null: false
    t.jsonb "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_saved_features_on_created_at"
    t.index ["feature_type"], name: "index_saved_features_on_feature_type"
    t.index ["geom"], name: "index_saved_features_on_geom", using: :gist
  end

  create_table "streets", force: :cascade do |t|
    t.string "name", null: false
    t.geography "geom", limit: {:srid=>4326, :type=>"geometry", :geographic=>true}, null: false
    t.jsonb "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["geom"], name: "index_streets_on_geom", using: :gist
    t.index ["name"], name: "index_streets_on_name"
  end

end
