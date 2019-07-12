class Reglementation < ApplicationRecord
  has_many :emplacement_reglementations
  has_many :places, through: :emplacement_reglementations

  has_many :reglementation_periodes
  has_many :periodes, through: :reglementation_periodes
end
