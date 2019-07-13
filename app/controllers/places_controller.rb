class PlacesController < ApplicationController
  def index
    address = params[:address]
    walking_radius = params[:walking]
    hours = params[:hours]

    geocoded_address = { latitude: 45.4900421, longitude: -73.5815461 } # This should be done via the geocoder

    places = Place.limit(10) # this is where the magic should happen ;)

    place_coordinates = places.map { |place| place.serializable_hash(only: [:longitude, :latitude]) }

    render json: { places: place_coordinates, destination: geocoded_address }
  end
end
