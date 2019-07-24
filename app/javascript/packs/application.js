import 'bootstrap';
import 'mapbox-gl/dist/mapbox-gl.css'
import mapboxgl from 'mapbox-gl';

// =============================================================================

const micBtn = document.querySelector("#mic-btn");
const infoCard = document.querySelector(".info-card");

micBtn.addEventListener("click", () => {
  infoCard.classList.toggle("show");
});
/*
const destination = document.getElementsByClassName('destination-marker');

destination.addEventListener("click", () => {
  console.log('help');
}); */

// =============================================================================

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
  userCoords = {
    latitude: 45.50884,
    longitude: -73.58781
  }

  // Add geolocate control to the map.
map.addControl(new mapboxgl.GeolocateControl({
  positionOptions: {
  enableHighAccuracy: true
  },
  trackUserLocation: true
  }));

  createCurrentLocationMarker()
    .setLngLat({ lat: userCoords.latitude, lng: userCoords.longitude })
    .addTo(map);
  map.flyTo({ center: { lat: userCoords.latitude, lng: userCoords.longitude }, zoom: 7, duration: 0 });
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

  infoCard.classList.remove("show");

  // building the query string
  const params = {}

  const address = form.querySelector("input[name='address']").value;
  const distance = form.querySelector("input[name='distance']").value;
  const duration = form.querySelector("input[name='duration']").value;

  if (address) { params.address = address }
  if (distance) { params.distance = distance }
  if (duration) { params.duration = duration }
  if (userCoords) {
    params.user_latitude = userCoords.latitude;
    params.user_longitude = userCoords.longitude;
  }

  const queryString = Object.keys(params).map(key => key + '=' + params[key]).join('&');

  // This is making an AJAX (fetch) request
  railsFetch(`${form.action}?${queryString}`, { method: form.method })
    .then(response => response.json())
    .then((data) => {
      const bounds = new mapboxgl.LngLatBounds();

      // Markers for the parking spots
      data.places.forEach((place) => {
        bounds.extend([ place.longitude, place.latitude ])

        createMarker()
          .setLngLat([ place.longitude, place.latitude ])
          .addTo(map);
      });

      map.fitBounds(bounds, { padding: 70, maxZoom: 18, linear: true });


      // Marker for the destination
      createDestinationMarker()
        .setLngLat([ data.destination.longitude, data.destination.latitude ])
        .addTo(map);

      bounds.extend([ data.destination.longitude, data.destination.latitude ]);
    });
})

const createMarker = () => {
  return new mapboxgl.Marker()
}

const popup = document.querySelector('.hidden');

const createDestinationMarker = () => {
  const markerDiv = document.createElement('div');
  markerDiv.className = 'destination-marker';
  markerDiv.addEventListener("click", () => {
    popup.classList.remove('hidden');
  });
  return new mapboxgl.Marker(markerDiv)
}

const createCurrentLocationMarker = () => {
  const markerDiv = document.createElement('div');
  markerDiv.className = 'current-location-marker';

  return new mapboxgl.Marker(markerDiv)
}

// Speech recognition


const recognition = new webkitSpeechRecognition();
recognition.continuous = true;
recognition.lang = 'en-US';
recognition.maxAlternatives = 1;
recognition.start();

const submitButton = document.querySelector("#find-parking");

const voiceInputs = {
  address: document.querySelector("#address"),
  duration: document.querySelector("#duration"),
  distance: document.querySelector("#distance")
}

let state = null;

recognition.onresult = function(event) {
  const latestResult = event.results[event.results.length - 1][0].transcript.toLowerCase().trim();

  if (state === null) {
    if (latestResult.match(/^destination$/)) {
      voiceInputs.address.parentNode.querySelector(".fa-microphone").style["-webkit-text-fill-color"] = "#7ae090"
      voiceInputs.duration.parentNode.querySelector(".fa-microphone").style["-webkit-text-fill-color"] = "#c9c9c9"
      voiceInputs.distance.parentNode.querySelector(".fa-microphone").style["-webkit-text-fill-color"] = "#c9c9c9"
      state = "address"
    } else if (latestResult.match(/^duration$/)) {
      voiceInputs.address.parentNode.querySelector(".fa-microphone").style["-webkit-text-fill-color"] = "#c9c9c9"
      voiceInputs.duration.parentNode.querySelector(".fa-microphone").style["-webkit-text-fill-color"] = "#7ae090"
      voiceInputs.distance.parentNode.querySelector(".fa-microphone").style["-webkit-text-fill-color"] = "#c9c9c9"
      state = "duration"
    } else if (latestResult.match(/^distance$/)) {
      voiceInputs.address.parentNode.querySelector(".fa-microphone").style["-webkit-text-fill-color"] = "#c9c9c9"
      voiceInputs.duration.parentNode.querySelector(".fa-microphone").style["-webkit-text-fill-color"] = "#c9c9c9"
      voiceInputs.distance.parentNode.querySelector(".fa-microphone").style["-webkit-text-fill-color"] = "#7ae090"
      state = "distance"
    } else if (latestResult.match(/^find parking$/)) {
      submitButton.click();
    }
  } else {
    voiceInputs[state].value = latestResult;
    voiceInputs.address.parentNode.querySelector(".fa-microphone").style["-webkit-text-fill-color"] = "#c9c9c9"
    voiceInputs.duration.parentNode.querySelector(".fa-microphone").style["-webkit-text-fill-color"] = "#c9c9c9"
    voiceInputs.distance.parentNode.querySelector(".fa-microphone").style["-webkit-text-fill-color"] = "#c9c9c9"
    state = null;
  }
}
