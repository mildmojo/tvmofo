module ApplicationHelper
  def active_controller? controller
    @_controller.class == controller ? ' active' : ''
  end
end
