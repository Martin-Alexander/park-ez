import 'bootstrap';
import 'mapbox-gl/dist/mapbox-gl.css'
import mapboxgl from 'mapbox-gl';

// Helper method for making AJAX request to a Rails controller
export const railsFetch = (input, init = {}) => {
  const deafultHeaders = {
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }

  init.headers = { ...init.headers, ...deafultHeaders };
  init.credentials = "same-origin";

  return fetch(input, init);
}

// Get users coordinates
let userCoords;

navigator.geolocation.getCurrentPosition((position) => {
  userCoords = position.coords;
  new mapboxgl.Marker()
    .setLngLat({ lat: userCoords.latitude, lng: userCoords.longitude })
    .addTo(map);
  map.flyTo({ center: { lat: userCoords.latitude, lng: userCoords.longitude }, zoom: 14, duration: 0 });
}, (error) => console.error, { enableHighAccuracy: true });


// Initialize the map
const mapElement = document.getElementById('map');
  mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;

  const map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v10'
  });

// Set up to form to make an AJAX request to places#index
const form = document.querySelector("form");

form.addEventListener("submit", (event) => {
  event.preventDefault();

  // This is making an AJAX (fetch) request
  railsFetch(form.action, { method: form.method })
    .then(response => response.json())
    .then((data) => {
      const bounds = new mapboxgl.LngLatBounds();

      // Marker for the destination
      new mapboxgl.Marker()
        .setLngLat([ data.destination.longitude, data.destination.latitude ])
        .addTo(map);

      bounds.extend([ data.destination.longitude, data.destination.latitude ]);

      // Markers for the parking spots
      data.places.forEach((place) => {
        bounds.extend([ place.longitude, place.latitude ])

        new mapboxgl.Marker()
          .setLngLat([ place.longitude, place.latitude ])
          .addTo(map);
      });

      map.fitBounds(bounds, { padding: 70, maxZoom: 16, linear: true });
    });
})