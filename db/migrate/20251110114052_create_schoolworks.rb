class CreateSchoolworks < ActiveRecord::Migration[8.0]
  def change
    create_table :schoolworks do |t|
      t.references :subject, null: false, foreign_key: true
      t.integer :schoolwork_type, null: false
      t.string :title, null: false
      t.text :description
      t.datetime :due_date
      t.integer :status
      t.integer :priority
      t.decimal :grade
      t.datetime :submitted_at

      t.timestamps
    end
  end
end
