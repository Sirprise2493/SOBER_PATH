// app/javascript/controllers/map_controller.js
import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static values = { apiKey: String, markers: Array, center: Object, radiusKm: Number }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })

    this.map.on("load", () => {
      // Diagnose
      console.log("markers:", this.markersValue)
      console.log("center:", this.centerValue)
      console.log("radiusKm:", this.radiusKmValue)

      this.#addMarkersToMap()
      if (this.centerValue?.lat && this.centerValue?.lng && this.radiusKmValue) {
        this.#drawRadiusCircle(this.centerValue, this.radiusKmValue)
        this.#fitToCircleOrMarkers()
      } else {
        this.#fitMapToMarkers()
      }
    })
  }

  #addMarkersToMap() {
    this._markerInstances = []
    if (!Array.isArray(this.markersValue)) return
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html || "")
      const m = new mapboxgl.Marker()
        .setLngLat([Number(marker.lng), Number(marker.lat)])
        .setPopup(popup)
        .addTo(this.map)
      this._markerInstances.push(m)
    })
  }

  #fitMapToMarkers() {
    if (!this.markersValue?.length) return
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(m => bounds.extend([Number(m.lng), Number(m.lat)]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 32, duration: 120 })
  }

  #fitToCircleOrMarkers() {
    const src = this.map.getSource("radius-circle")
    if (src && src._data?.features?.[0]) {
      const coords = src._data.features[0].geometry.coordinates[0]
      const bounds = new mapboxgl.LngLatBounds()
      coords.forEach(([lng, lat]) => bounds.extend([lng, lat]))
      this.map.fitBounds(bounds, { padding: 70, maxZoom: 32, duration: 120 })
    } else {
      this.#fitMapToMarkers()
    }
  }

  #makeCircle(center, radiusKm, points = 128) {
    const coords = []
    const dx = radiusKm / (111.32 * Math.cos(center.lat * Math.PI / 180))
    const dy = radiusKm / 110.574
    for (let i = 0; i <= points; i++) {
      const t = (i / points) * 2 * Math.PI
      const lng = center.lng + (dx * Math.sin(t))
      const lat = center.lat + (dy * Math.cos(t))
      coords.push([lng, lat])
    }
    return {
      type: "FeatureCollection",
      features: [{ type: "Feature", properties: {}, geometry: { type: "Polygon", coordinates: [coords] } }]
    }
  }

  #drawRadiusCircle(center, radiusKm) {
    const data = this.#makeCircle(center, radiusKm)
    if (this.map.getSource("radius-circle")) {
      this.map.getSource("radius-circle").setData(data)
      return
    }
    this.map.addSource("radius-circle", { type: "geojson", data })
    this.map.addLayer({ id: "radius-fill", type: "fill", source: "radius-circle", paint: { "fill-opacity": 0.1 } })
    this.map.addLayer({ id: "radius-outline", type: "line", source: "radius-circle", paint: { "line-width": 2 } })
  }
}
