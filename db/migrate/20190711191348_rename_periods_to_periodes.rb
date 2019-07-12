class RenamePeriodsToPeriodes < ActiveRecord::Migration[5.2]
  def change
    rename_table :periods, :periodes
  end
end
