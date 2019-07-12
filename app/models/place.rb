class Place < ApplicationRecord
  has_many :emplacement_reglementations
  has_many :reglementations, through: :emplacement_reglementations
  has_many :periodes, through: :reglementations
end
