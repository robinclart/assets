module Assetable
  extend ActiveSupport::Concern

  included do
    prepend Extension
    has_many :assets, as: :assetable
  end

  def asset(column)
    @_asset ||= {}
    return @_asset[column] if @_asset[column]

    if column_id = read_attribute("#{column}_id").presence
      @_asset[column] = assets.find(column_id)
    else
      @_asset[column] = assets.build
    end

    @_asset[column]
  end

  module Extension
    def read_uploader(column)
      asset(column).filename
    end

    def write_uploader(column, identifier)
      asset(column).filename = identifier
    end
  end

  module ClassMethods
    def asset(column)
      mount_uploader column, "#{self.name}#{column.to_s.camelcase}Uploader".constantize

      define_method "#{column}_will_change!" do
        attribute_will_change! "#{column}".to_sym
      end

      define_method "#{column}_changed?" do
        changed.include? "#{column}".to_sym
      end
    end
  end
end