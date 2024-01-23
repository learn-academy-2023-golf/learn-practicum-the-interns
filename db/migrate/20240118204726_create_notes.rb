class CreateNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :notes do |t|
      t.references :team, null: false, foreign_key: true
      t.references :creator, null: false, foreign_key: {to_table: "memberships"}
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
