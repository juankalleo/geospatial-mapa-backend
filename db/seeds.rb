# Clear existing data
puts "Clearing existing data..."
SavedFeature.destroy_all
Street.destroy_all
LandArea.destroy_all

# Factory for creating geometries
factory = RGeo::Geographic.spherical_factory(srid: 4326)

# Nova Mamoré coordinates (center)
# Approximate bounding box: lng: -65.35 to -65.31, lat: -10.42 to -10.39

puts "Creating sample streets..."

streets_data = [
  { name: "Avenida Brasil", coords: [[-65.3344, -10.4066], [-65.3320, -10.4066], [-65.3300, -10.4066]] },
  { name: "Rua das Flores", coords: [[-65.3344, -10.4050], [-65.3320, -10.4050], [-65.3300, -10.4050]] },
  { name: "Rua Principal", coords: [[-65.3330, -10.4100], [-65.3330, -10.4080], [-65.3330, -10.4060], [-65.3330, -10.4040]] },
  { name: "Avenida Central", coords: [[-65.3350, -10.4070], [-65.3340, -10.4070], [-65.3330, -10.4070], [-65.3320, -10.4070]] },
  { name: "Rua do Comércio", coords: [[-65.3340, -10.4055], [-65.3335, -10.4055], [-65.3330, -10.4055]] }
]

streets_data.each do |street_data|
  points = street_data[:coords].map { |c| factory.point(c[0], c[1]) }
  line = factory.line_string(points)
  
  Street.create!(
    name: street_data[:name],
    geom: line,
    properties: { type: 'primary' }
  )
end

puts "Created #{Street.count} streets"

puts "Creating sample land areas..."

# Indigenous land
indigenous_coords = [
  [-65.3380, -10.4100],
  [-65.3360, -10.4100],
  [-65.3360, -10.4080],
  [-65.3380, -10.4080],
  [-65.3380, -10.4100]
]
indigenous_points = indigenous_coords.map { |c| factory.point(c[0], c[1]) }
indigenous_poly = factory.polygon(factory.linear_ring(indigenous_points))

LandArea.create!(
  name: "Terra Indígena Exemplo",
  area_type: "indigenous_land",
  geom: indigenous_poly,
  properties: { tribe: "Exemplo", status: "demarcated" }
)

# Water body
water_coords = [
  [-65.3310, -10.4090],
  [-65.3300, -10.4090],
  [-65.3300, -10.4085],
  [-65.3310, -10.4085],
  [-65.3310, -10.4090]
]
water_points = water_coords.map { |c| factory.point(c[0], c[1]) }
water_poly = factory.polygon(factory.linear_ring(water_points))

LandArea.create!(
  name: "Rio Exemplo",
  area_type: "water",
  geom: water_poly,
  properties: { water_type: "river" }
)

# Protected area
protected_coords = [
  [-65.3370, -10.4050],
  [-65.3350, -10.4050],
  [-65.3350, -10.4030],
  [-65.3370, -10.4030],
  [-65.3370, -10.4050]
]
protected_points = protected_coords.map { |c| factory.point(c[0], c[1]) }
protected_poly = factory.polygon(factory.linear_ring(protected_points))

LandArea.create!(
  name: "Área de Preservação Ambiental",
  area_type: "protected_area",
  geom: protected_poly,
  properties: { protection_level: "high" }
)

puts "Created #{LandArea.count} land areas"

puts "Creating sample saved features..."

# Sample polygon
sample_poly_coords = [
  [-65.3335, -10.4065],
  [-65.3325, -10.4065],
  [-65.3325, -10.4060],
  [-65.3335, -10.4060],
  [-65.3335, -10.4065]
]
sample_poly_points = sample_poly_coords.map { |c| factory.point(c[0], c[1]) }
sample_polygon = factory.polygon(factory.linear_ring(sample_poly_points))

SavedFeature.create!(
  name: "Área de Exemplo",
  description: "Esta é uma área de exemplo criada no seed",
  feature_type: "polygon",
  geom: sample_polygon,
  properties: { color: "#3b82f6" }
)

puts "Created #{SavedFeature.count} saved features"
puts "Seed completed successfully!"
