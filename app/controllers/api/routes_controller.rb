module Api
  class RoutesController < ApplicationController
    # POST /api/route
    # Params: { from: [lng, lat], to: [lng, lat] }
    def calculate
      from = params[:from]
      to = params[:to]

      unless valid_coordinates?(from) && valid_coordinates?(to)
        render json: { error: 'Invalid coordinates' }, status: :bad_request
        return
      end

      # Simple straight line route (replace with OSRM/pgRouting in production)
      route = calculate_simple_route(from, to)
      
      render json: route
    end

    private

    def valid_coordinates?(coords)
      coords.is_a?(Array) && coords.length == 2 &&
        coords[0].is_a?(Numeric) && coords[1].is_a?(Numeric) &&
        coords[0].between?(-180, 180) && coords[1].between?(-90, 90)
    end

    def calculate_simple_route(from, to)
      # Create a simple LineString between two points
      factory = RGeo::Geographic.spherical_factory(srid: 4326)
      
      point_a = factory.point(from[0], from[1])
      point_b = factory.point(to[0], to[1])
      
      line = factory.line_string([point_a, point_b])
      
      # Calculate distance in meters
      distance_m = point_a.distance(point_b) * 111_320 # Approximate meters per degree
      
      # Estimate duration (assuming 50 km/h average speed)
      duration_s = (distance_m / 1000.0) / 50.0 * 3600.0
      
      {
        type: 'Feature',
        geometry: RGeo::GeoJSON.encode(line),
        properties: {
          distance_m: distance_m.round(2),
          distance_km: (distance_m / 1000.0).round(2),
          duration_s: duration_s.round(0),
          duration_min: (duration_s / 60.0).round(1)
        }
      }
    end
  end
end
