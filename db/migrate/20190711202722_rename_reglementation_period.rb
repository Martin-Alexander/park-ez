class RenameReglementationPeriod < ActiveRecord::Migration[5.2]
  def change
    rename_table :reglementation_periods, :reglementation_periodes
  end
end
