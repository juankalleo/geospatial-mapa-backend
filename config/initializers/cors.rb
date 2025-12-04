'use client'
import React, { useRef, useEffect } from 'react'
import maplibregl from 'maplibre-gl'
import 'maplibre-gl/dist/maplibre-gl.css'
import { DEFAULT_MAP_CONFIG, BASE_STYLE, MAPTILER_KEY } from '@/lib/map-config'
import { useMapStore } from '@/lib/map-store'

export function MapContainer() {
  const mapContainer = useRef<HTMLDivElement | null>(null)
  const { setMap } = useMapStore()

  useEffect(() => {
    if (!mapContainer.current) return

    // use map-config BASE_STYLE which já aplica fallback de satélite
    const style: any = BASE_STYLE(MAPTILER_KEY)

    const map = new maplibregl.Map({
      container: mapContainer.current,
      style,
      ...DEFAULT_MAP_CONFIG,
    })

    map.on('load', () => {
      console.log('[v0] Map loaded successfully')
      // expõe para debug
      // @ts-ignore
      window.__MAP = map
      setMap(map)
    })

    // controls
    map.addControl(new maplibregl.NavigationControl({ showCompass: true, showZoom: true }), 'top-right')
    map.addControl(new maplibregl.ScaleControl({ maxWidth: 200, unit: 'metric' }), 'bottom-left')

    return () => {
      try {
        map.remove()
      } catch {}
      setMap(undefined)
    }
  }, [setMap])

  const setBaseLayer = (id: 'osm' | 'satellite') => {
    const map = get().map as maplibregl.Map | undefined
    if (!map) return
    try {
      // remove existing layer (if present) and re-add referencing desired source,
      // isso simplifica a troca e mantém id consistente 'base-raster'
      if (map.getLayer('base-raster')) {
        map.removeLayer('base-raster')
      }
      // ensure sources exist (map style from BASE_STYLE already has 'osm' and 'satellite')
      if (!map.getSource(id)) {
        console.warn('[mapstore] source not found:', id)
      }
      map.addLayer(
        {
          id: 'base-raster',
          type: 'raster',
          source: id,
        } as any,
        undefined,
      )
      console.debug('[mapstore] setBaseLayer ->', id)
    } catch (e) {
      console.warn('[mapstore] setBaseLayer error', e)
    }
  }

  const toggleBaseLayer = () => {
    const map = get().map as maplibregl.Map | undefined
    if (!map) return
    try {
      const baseLayer = (map.getStyle()?.layers as any || []).find((l: any) => l.id === 'base-raster')
      const curSource = baseLayer?.source || 'osm'
      const next = curSource === 'osm' ? 'satellite' : 'osm'
      setBaseLayer(next as 'osm' | 'satellite')
      console.debug('[mapstore] toggleBaseLayer', { from: curSource, to: next })
    } catch (e) {
      console.warn('[mapstore] toggleBaseLayer error', e)
    }
  }

  return (
    <div className="relative w-full h-screen">
      <div id="map" ref={mapContainer} className="absolute inset-0 h-full" />
    </div>
  )
}
