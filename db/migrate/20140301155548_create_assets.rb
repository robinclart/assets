class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :filename
      t.references :assetable, index: true, polymorphic: true

      t.timestamps
    end
  end
end
