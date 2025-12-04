module Api
  class StreetsController < ApplicationController
    # GET /api/streets?search=query
    def index
      query = params[:search]
      
      if query.blank?
        render json: { features: [] }
        return
      end

      @streets = Street.search_by_name(query)
      
      render json: {
        type: 'FeatureCollection',
        features: @streets.map do |street|
          street.to_geojson.merge(
            properties: street.to_geojson[:properties].merge(
              centroid: street.centroid
            )
          )
        end
      }
    end
  end
end
