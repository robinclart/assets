require 'test_helper'

class AssetTest < ActiveSupport::TestCase
  test "that an asset can be build on an unsaved record" do
    store = Store.new
    assert_instance_of StoreFaviconUploader, store.favicon
    assert_instance_of Asset, store.asset(:favicon)
    assert store.asset(:favicon).new_record?
    assert_nil store.asset(:favicon).assetable
  end

  test "that the asset is saved when the parent is saved" do
    store = Store.new
    store.asset(:favicon)
    store.save
    assert store.asset(:favicon).persisted?
    assert_instance_of Store, Asset.first.assetable
  end
end
