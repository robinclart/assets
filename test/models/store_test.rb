require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  test "that I can create a store" do
    assert Store.create
  end

  test "that I can build a store then save it" do
    assert Store.new.save
  end
end
