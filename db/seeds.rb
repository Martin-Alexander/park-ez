require "csv"

csv_options = { headers: true, encoding: "ISO8859-1", header_converters: :symbol }

places_csv                      = CSV.readlines(Rails.root.join("db", "csv", "Places.csv"), csv_options)
reglementations_csv             = CSV.readlines(Rails.root.join("db", "csv", "Reglementations.csv"), csv_options)
emplacement_reglementations_csv = CSV.readlines(Rails.root.join("db", "csv", "EmplacementReglementation.csv"), csv_options)
periodes_csv                    = CSV.readlines(Rails.root.join("db", "csv", "Periodes.csv"), csv_options)
reglementation_periodes_csv     = CSV.readlines(Rails.root.join("db", "csv", "ReglementationPeriode.csv"), csv_options)

# Their DB uses strings as primary keys, this method will turn a key like "AH-CC" into 6572456767
def convert_string_id_to_integer(string_id)
  string_id.bytes.join.to_i
end

places_csv.each do |place_row|
  Place.create!({
    id: convert_string_id_to_integer(place_row[:snoplace]),
    longitude: place_row[:nlongitude],
    latitude: place_row[:nlatitude],
    statut: place_row[:sstatut],
    genre: place_row[:sgenre],
    place_type: place_row[:stype],
    autre_tete: place_row[:sautretete],
    nom_rue: place_row[:snomrue],
    sup_velo: place_row[:nsupvelo],
    type_exploitation: place_row[:stypeexploitation],
    postion_centre_longitude: place_row[:npositioncentrelongitude],
    postion_centre_latitude: place_row[:npositioncentrelatitude],
    tarif_horaire: place_row[:ntarifhoraire],
    localisation: place_row[:slocalisation],
    tarif_max: place_row[:ntarifmax]
  })
end

reglementations_csv.each do |reglementation_row|
  Reglementation.create!({
    id: convert_string_id_to_integer(reglementation_row[:name]),
    type_reglementation: reglementation_row[:type],
    date_debut: reglementation_row[:datedebut],
    date_fin: reglementation_row[:datefin],
    duree_max: reglementation_row[:maxheures]
  })
end

emplacement_reglementations_csv.each do |emplacement_reglementation_row|
  EmplacementReglementation.create!({
    place_id: convert_string_id_to_integer(emplacement_reglementation_row[:snoemplacement]),
    reglementation_id: convert_string_id_to_integer(emplacement_reglementation_row[:scodeautocollant])
  })
end

periodes_csv.each do |periode_row|
  Periode.create!({
    id: periode_row[:nid],
    heure_debut: periode_row[:dtheuredebut],
    heire_fin: periode_row[:dtheurefin],
    applique_lundi: periode_row[:blun],
    applique_mardi: periode_row[:bmar],
    applique_mercredi: periode_row[:bmer],
    applique_jeudi: periode_row[:bjeu],
    applique_vendredi: periode_row[:bven],
    applique_samedi: periode_row[:bsam],
    applique_dimanche: periode_row[:bdim],
  })
end

reglementation_periodes_csv.each do |reglementation_periode_row|
  ReglementationPeriode.create!({
    reglementation_id: convert_string_id_to_integer(reglementation_periode_row[:scode]),
    periode_id: reglementation_periode_row[:noperiode],
    description: reglementation_periode_row[:sDescription]
  })
end