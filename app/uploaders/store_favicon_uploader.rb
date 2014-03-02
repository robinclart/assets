# encoding: utf-8

class StoreFaviconUploader < AssetUploader
  version :thumb do
    process resize_to_fill: [16, 16]
  end
end
