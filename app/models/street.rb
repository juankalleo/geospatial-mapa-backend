class Street < ApplicationRecord
  validates :name, presence: true
  validates :geom, presence: true

  # Search streets by name
  scope :search_by_name, ->(query) {
    where("LOWER(name) LIKE ?", "%#{query.downcase}%")
      .limit(10)
  }

  # Convert to GeoJSON Feature
  def to_geojson
    {
      type: 'Feature',
      id: id,
      geometry: RGeo::GeoJSON.encode(geom),
      properties: {
        name: name
      }.merge(properties || {})
    }
  end

  # Get centroid for focusing map
  def centroid
    result = ActiveRecord::Base.connection.select_one(
      "SELECT ST_Y(ST_Centroid(geom)) as lat, ST_X(ST_Centroid(geom)) as lng FROM streets WHERE id = #{id}"
    )
    [result['lng'].to_f, result['lat'].to_f] if result
  end
end
