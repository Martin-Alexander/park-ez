class Periode < ApplicationRecord
  has_many :reglementation_periodes
  has_many :reglementations, through: :reglementation_periodes
  has_many :places, through: :reglementations
end
