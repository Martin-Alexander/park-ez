class CreateReglementations < ActiveRecord::Migration[5.2]
  def change
    create_table :reglementations do |t|
      t.string :type_reglementation
      t.integer :date_debut
      t.integer :date_fin
      t.integer :duree_max

      t.timestamps
    end
  end
end
