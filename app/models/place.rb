require "geocoder/stores/active_record"

class Place < ApplicationRecord
  include Geocoder::Store::ActiveRecord
  has_many :emplacement_reglementations
  has_many :reglementations, through: :emplacement_reglementations
  has_many :periodes, through: :reglementations

  def self.geocoder_options
    { latitude: 'latitude', longitude: 'longitude' }
  end
end
