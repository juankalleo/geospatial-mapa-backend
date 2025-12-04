module Api
  class SavedFeaturesController < ApplicationController
    before_action :set_saved_feature, only: [:show, :update, :destroy]

    # GET /api/saved_features
    def index
      @features = SavedFeature.recent
      render json: @features.to_feature_collection
    end

    # GET /api/saved_features/:id
    def show
      render json: @feature.to_geojson
    end

    # POST /api/saved_features
    def create
      @feature = SavedFeature.new(saved_feature_params)

      if @feature.save
        render json: @feature.to_geojson, status: :created
      else
        render json: { errors: @feature.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PUT/PATCH /api/saved_features/:id
    def update
      if @feature.update(saved_feature_params)
        render json: @feature.to_geojson
      else
        render json: { errors: @feature.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/saved_features/:id
    def destroy
      @feature.destroy
      head :no_content
    end

    private

    def set_saved_feature
      @feature = SavedFeature.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Feature not found' }, status: :not_found
    end

    def saved_feature_params
      geom_param = params.require(:saved_feature).permit(:name, :description, :feature_type, geom: {})[:geom]
      
      # Convert GeoJSON to RGeo geometry
      geom = if geom_param.is_a?(Hash)
        RGeo::GeoJSON.decode(geom_param.to_json, geo_factory: RGeo::Geographic.spherical_factory(srid: 4326))
      else
        nil
      end

      params.require(:saved_feature).permit(:name, :description, :feature_type, properties: {}).merge(geom: geom)
    end
  end
end
