class CreatePeriods < ActiveRecord::Migration[5.2]
  def change
    create_table :periods do |t|
      t.time :heure_debut
      t.time :heire_fin
      t.boolean :applique_lundi
      t.boolean :applique_mardi
      t.boolean :applique_mercredi
      t.boolean :applique_jeudi
      t.boolean :applique_vendredi
      t.boolean :applique_samedi
      t.boolean :applique_dimanche

      t.timestamps
    end
  end
end
