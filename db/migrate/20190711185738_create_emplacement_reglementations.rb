class CreateEmplacementReglementations < ActiveRecord::Migration[5.2]
  def change
    create_table :emplacement_reglementations do |t|
      t.references :place, foreign_key: true
      t.references :reglementation, foreign_key: true

      t.timestamps
    end
  end
end
