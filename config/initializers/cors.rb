Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # em produção troque por 'https://geospatial-mapa.vercel.app'
    resource '/api/*',
      headers: :any,
      methods: %i[get post put patch delete options head],
      credentials: true
  end
end

export const MAP_STYLES = {
  // Teste rápido — style público compatível com maplibre
  OSM: "https://demotiles.maplibre.org/style.json",
  // Satellite: prefer MapTiler (quando existir chave pública NEXT_PUBLIC_MAPTILER_KEY),
  // fallback para Esri World Imagery caso não tenha chave.
  SATELLITE_MAPTILER: (key?: string) =>
    key ? `https://api.maptiler.com/tiles/hybrid/{z}/{x}/{y}.jpg?key=${key}` : null,
  SATELLITE_ESRI: "https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
}

// build a simple vector-less style with two raster sources:
const maptilerKey = process.env.NEXT_PUBLIC_MAPTILER_KEY
const satelliteTiles = maptilerKey
  ? `https://api.maptiler.com/tiles/hybrid/{z}/{x}/{y}.jpg?key=${maptilerKey}`
  : "https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"

const style: any = {
  version: 8,
  name: 'local-raster-style',
  sources: {
    osm: {
      type: 'raster',
      tiles: [
        // 512 tiles endpoint for sharper tiles on high-dpi devices can be used if available.
        'https://a.tile.openstreetmap.org/{z}/{x}/{y}.png'
      ],
      tileSize: 256,
      attribution: '© OpenStreetMap contributors',
    },
    satellite: {
      type: 'raster',
      tiles: [satelliteTiles],
      tileSize: 256,
      attribution: maptilerKey ? '© MapTiler' : 'Esri World Imagery',
    },
  },
  layers: [
    // default layer (referência por id 'base-raster')
    {
      id: 'base-raster',
      type: 'raster',
      source: 'osm',
    },
  ],
}
