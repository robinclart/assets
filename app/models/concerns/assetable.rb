module Assetable
  extend ActiveSupport::Concern

  included do
    prepend Extension
    has_many :assets, as: :assetable
  end

  # Public: Returns the `Asset` record directly, not the uploader that is
  # mounted on the column.
  #
  # column - the name of the column for which we need an asset.
  #
  # The asset model has an additional property called `assetable_scope` that is
  # responsible for declaring to which local column it is associated.
  # This lets us to declare assets completely dynamically without the need to
  # alter the table at all.
  def asset(column)
    @_asset ||= {}
    return @_asset[column] if @_asset[column]

    @_asset[column] = assets.where(assetable_scope: column).first

    unless @_asset[column]
      @_asset[column] = assets.build(assetable_scope: column)
    end

    @_asset[column]
  end

  module Extension 
    # Private: Gets the identifier from the asset column.
    def read_uploader(column)
      asset(column).filename
    end

    # Private: Sets the identifier on the asset column.
    #
    # Not that this doesn't save the asset directly. It's still required to
    # save the local record to persist the asset.
    def write_uploader(column, identifier)
      asset(column).filename = identifier
    end
  end

  module ClassMethods
    # Mount an uploader on an non existant column then define the dirty tracking
    # methods required by carrierwave to work.
    #
    # The name of the uploader is defined dynamically by taking the name of the
    # class followed by the name of the column. For example If you call
    # `asset :favicon` on a `Store` model, the uploader `StoreFaviconUploader`
    # will be required for that column.
    #
    # TODO: I'd be so much easier if we didn't have to setup the dirty tracking
    # methods ourselves. We could try to send a patch to CW so they use the
    # dynamic methods instead of the named one.
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