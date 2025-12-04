class LandArea < ApplicationRecord
  validates :name, presence: true
  validates :area_type, presence: true, inclusion: { 
    in: %w[indigenous_land protected_area water],
    message: "%{value} is not a valid area type" 
  }
  validates :geom, presence: true

  # Scopes
  scope :by_type, ->(type) { where(area_type: type) }
  scope :indigenous_lands, -> { where(area_type: 'indigenous_land') }
  scope :protected_areas, -> { where(area_type: 'protected_area') }
  scope :water_bodies, -> { where(area_type: 'water') }

  # Convert to GeoJSON Feature
  def to_geojson
    {
      type: 'Feature',
      id: id,
      geometry: RGeo::GeoJSON.encode(geom),
      properties: {
        name: name,
        area_type: area_type
      }.merge(properties || {})
    }
  end

  # Class method to return FeatureCollection by type
  def self.to_feature_collection(type = nil)
    scope = type.present? ? by_type(type) : all
    {
      type: 'FeatureCollection',
      features: scope.map(&:to_geojson)
    }
  end
end
