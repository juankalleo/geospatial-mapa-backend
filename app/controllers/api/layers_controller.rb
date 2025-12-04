module Api
  class LayersController < ApplicationController
    # GET /api/layers?type=indigenous_land
    def index
      type = params[:type]
      
      unless type.blank? || %w[indigenous_land protected_area water].include?(type)
        render json: { error: 'Invalid layer type' }, status: :bad_request
        return
      end

      @areas = type.present? ? LandArea.by_type(type) : LandArea.all
      
      render json: @areas.to_feature_collection(type)
    end
  end
end
