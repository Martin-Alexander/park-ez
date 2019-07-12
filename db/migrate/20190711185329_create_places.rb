class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.float :longitude
      t.float :latitude
      t.string :statut
      t.string :genre
      t.string :type
      t.string :autre_tete
      t.string :nom_rue
      t.integer :sup_velo
      t.string :type_exploitation
      t.float :postion_centre_longitude
      t.float :postion_centre_latitude
      t.integer :tarif_horaire
      t.string :localisation
      t.integer :tarif_max

      t.timestamps
    end
  end
end
