class AddNumberIndexToPoll < ActiveRecord::Migration[7.1]
  def change
    add_index :polls, [:number, :riding_id], unique: true
  end
end
