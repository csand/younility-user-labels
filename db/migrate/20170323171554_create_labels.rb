class CreateLabels < ActiveRecord::Migration[5.0]
  def change
    create_table :labels do |t|
      t.timestamps
      t.string 'name', null: false
      t.string 'color', null: false
    end

    add_index :labels, [:name, :color], unique: true
    create_join_table :users, :labels
  end
end
