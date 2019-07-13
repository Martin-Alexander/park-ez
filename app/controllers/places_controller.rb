class PlacesController < ApplicationController
  def index
    address = params[:address]
    walking_radius = params[:walking]
    hours = params[:hours]

    first_result = Geocoder.search(address)[0]

    if first_result
      address_coordinates = { latitude: first_result.data["lat"].to_i, longitude: first_result.data["lng"].to_i }
    else
      # binding.pry
      address_coordinates = { latitude: 45.4900421, longitude: -73.5815461 } # backup
    end

    places = Place.limit(10) # this is where the magic should happen ;)

    place_coordinates = places.map { |place| place.serializable_hash(only: [:longitude, :latitude]) }

    render json: { places: place_coordinates, destination: address_coordinates }
  end

  
end
