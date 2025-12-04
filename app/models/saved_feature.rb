class SavedFeature < ApplicationRecord
  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :feature_type, presence: true, inclusion: { 
    in: %w[polygon line point circle route],
    message: "%{value} is not a valid feature type" 
  }
  validates :geom, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_type, ->(type) { where(feature_type: type) }

  # Convert to GeoJSON Feature
  def to_geojson
    {
      type: 'Feature',
      id: id,
      geometry: RGeo::GeoJSON.encode(geom),
      properties: {
        name: name,
        description: description,
        feature_type: feature_type,
        created_at: created_at.iso8601,
        updated_at: updated_at.iso8601
      }.merge(properties || {})
    }
  end

  # Class method to return FeatureCollection
  def self.to_feature_collection
    {
      type: 'FeatureCollection',
      features: all.map(&:to_geojson)
    }
  end

  # Calculate area for polygons (in square meters)
  def area_m2
    return nil unless %w[polygon circle].include?(feature_type)
    ActiveRecord::Base.connection.select_value(
      "SELECT ST_Area(ST_Transform(geom, 32720)) FROM saved_features WHERE id = #{id}"
    )&.to_f
  end

  # Calculate length for lines (in meters)
  def length_m
    return nil unless %w[line route].include?(feature_type)
    ActiveRecord::Base.connection.select_value(
      "SELECT ST_Length(ST_Transform(geom, 32720)) FROM saved_features WHERE id = #{id}"
    )&.to_f
  end

  private

  # Sanitize geometry before save
  def sanitize_geometry
    return unless geom_changed?
    
    # Ensure geometry is valid
    if geom && !geom.valid?
      self.geom = geom.buffer(0) # Attempt to fix invalid geometry
    end
  end
end
