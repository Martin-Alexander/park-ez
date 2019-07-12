class RenameTypeToPlaceType < ActiveRecord::Migration[5.2]
  def change
    rename_column :places, :type, :place_type
  end
end
