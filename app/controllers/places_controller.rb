class PlacesController < ApplicationController
  def index
    address = params[:address].blank? ? "5333 Ave Casgrain" : params[:address]
    distance = params[:distance].blank? ? 0.2 : params[:distance].to_i * 0.05
    duration = params[:duration].blank? ? 2 : params[:duration].to_i

    user_coords = {
      latitude: params[:user_latitude].to_f,
      longitude: params[:user_longitude].to_f
    }

    destination = Geocoder.search(address + ", montreal")[0]

    if destination
      address_coordinates = { latitude: destination.data["lat"].to_f, longitude: destination.data["lon"].to_f }
    else
      address_coordinates = { latitude: 45.4900421, longitude: -73.5815461 } # backup
      place_coordinates = Place.limit(10).map { |place| place.serializable_hash(only: [:longitude, :latitude]) }
    end

    places = Place
      .joins(:periodes)
      .near(address + ", montreal", distance)
      .where("periodes.heure_debut < ? AND periodes.heire_fin > ?", Time.now, Time.now + duration.hour)
      .uniq

    if places.length > 0
      place_coordinates = places.map { |place| place.serializable_hash(only: [:longitude, :latitude]) }
    else
      address_coordinates = { latitude: 45.4900421, longitude: -73.5815461 } # backup
      place_coordinates = Place.limit(10).map { |place| place.serializable_hash(only: [:longitude, :latitude]) }
    end


    render json: { places: place_coordinates, destination: address_coordinates }
  end

  
end
