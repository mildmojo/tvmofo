class Device < ActiveRecord::Base
  attr_accessible :address, :name, :port, :is_stream_target

  after_save :make_stream_target_exclusive, if: ->{ is_stream_target_changed? &&
                                                    is_stream_target }

  def stream_target?
    is_stream_target
  end

  ##############################################################################
  private
  ##############################################################################

  def make_stream_target_exclusive
    Device.where( 'id != ?', id ).update_all( is_stream_target: false )
  end
end
