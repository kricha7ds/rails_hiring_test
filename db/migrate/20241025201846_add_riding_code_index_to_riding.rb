class AddRidingCodeIndexToRiding < ActiveRecord::Migration[7.1]
  def change
    add_index :ridings, :riding_code, unique: true
  end
end
