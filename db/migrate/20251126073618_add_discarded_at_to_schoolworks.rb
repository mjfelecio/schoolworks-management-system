class AddDiscardedAtToSchoolworks < ActiveRecord::Migration[8.0]
  def change
    add_column :schoolworks, :discarded_at, :datetime
    add_index :schoolworks, :discarded_at
  end
end
