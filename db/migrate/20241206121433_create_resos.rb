class CreateResos < ActiveRecord::Migration[8.0]
  def change
    create_table :resos do |t|
      t.string :name

      t.timestamps
    end
  end
end