class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.integer :favicon_id

      t.timestamps
    end
  end
end
