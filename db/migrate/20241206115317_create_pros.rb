class CreatePros < ActiveRecord::Migration[8.0]
  def change
    create_table :pros do |t|
      t.string :name
      t.text :desc

      t.timestamps
    end
  end
end
