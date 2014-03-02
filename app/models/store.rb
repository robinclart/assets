class Store < ActiveRecord::Base
  include Assetable

  asset :favicon
end
