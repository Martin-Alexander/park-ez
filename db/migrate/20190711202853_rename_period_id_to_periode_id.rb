class RenamePeriodIdToPeriodeId < ActiveRecord::Migration[5.2]
  def change
    rename_column :reglementation_periodes, :period_id, :periode_id
  end
end
