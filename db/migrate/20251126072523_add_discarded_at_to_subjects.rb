class AddDiscardedAtToSubjects < ActiveRecord::Migration[8.0]
  def change
    add_column :subjects, :discarded_at, :datetime
    add_index :subjects, :discarded_at
  end
end
