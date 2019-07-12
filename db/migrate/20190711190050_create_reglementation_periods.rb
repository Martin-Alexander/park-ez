class CreateReglementationPeriods < ActiveRecord::Migration[5.2]
  def change
    create_table :reglementation_periods do |t|
      t.references :reglementation, foreign_key: true
      t.references :period, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
