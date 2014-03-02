class AddAssetableScopeToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :assetable_scope, :string
  end
end
