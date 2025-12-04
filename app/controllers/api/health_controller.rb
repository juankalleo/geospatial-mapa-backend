module Api
  class HealthController < ApplicationController
    def index
      render json: {
        status: 'ok',
        timestamp: Time.current.iso8601,
        database: database_status,
        postgis: postgis_status
      }
    end

    private

    def database_status
      ActiveRecord::Base.connection.execute('SELECT 1')
      'connected'
    rescue
      'disconnected'
    end

    def postgis_status
      result = ActiveRecord::Base.connection.execute('SELECT PostGIS_Version()')
      result.first['postgis_version']
    rescue
      'not available'
    end
  end
end
