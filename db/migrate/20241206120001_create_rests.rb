class CreateRests < ActiveRecord::Migration[8.0]
  def change
    create_table :rests do |t|
      t.string :name

      t.timestamps
    end
  end
end
