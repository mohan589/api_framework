class CreateDemos < ActiveRecord::Migration[8.0]
  def change
    create_table :demos do |t|
      t.string :name

      t.timestamps
    end
  end
end
